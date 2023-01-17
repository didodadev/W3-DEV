<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_app.cfm">
	<cfquery name="get_app_pos" datasource="#dsn#">
		SELECT * FROM EMPLOYEES_APP_POS WHERE EMPAPP_ID = #get_app.empapp_id#	
	</cfquery>
<cf_ajax_list>
	<cfif get_app_pos.recordcount>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='55159.İlan'></th>
            <th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
            <th>&nbsp;</th>
        </tr>
    </thead>
	<tbody>
		<cfoutput query="get_app_pos">
			<tr>
				<td>
				<cfif len(#get_app_pos.notice_id#)>
					<cfquery name="GET_NOTICES" datasource="#DSN#">
						SELECT NOTICE_HEAD,NOTICE_NO,STATUS FROM NOTICES WHERE NOTICE_ID=#get_app_pos.notice_id# 
					</cfquery>
					#GET_NOTICES.notice_no#-#GET_NOTICES.notice_head#
				<cfelseif len(#get_app_pos.position_id#)>
				</cfif>
				</td>
				<td>#DateFormat(get_app_pos.app_date,dateformat_style)#</td>
				<td width="15"><a href="#request.self#?fuseaction=hr.apps&event=upd&empapp_id=#empapp_id#&app_pos_id=#app_pos_id#" ><i class="fa fa-pencil"></a></td>	
			</tr>
		</cfoutput>
    </tbody>
	<cfelse>
    	<tbody>
            <tr>
                <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
            </tr>
        </tbody>
	</cfif>
</cf_ajax_list>

