<cfquery name="get_req" datasource="#DSN#">
  SELECT 
    * 
  FROM 
    SETUP_REQ_TYPE
</cfquery>
<cfquery name="get_consumer_req" datasource="#dsn#"> 
	SELECT 
    	REQ_ID
	FROM 
    	MEMBER_REQ_TYPE
	WHERE 
    	CONSUMER_ID=#attributes.consumer_id#
</cfquery>
<cfset liste = valuelist(get_consumer_req.req_id)>
<cf_box title="#getLang('','Yetkinlikler','58709')#" popup_box="1">
	<cfform action="#request.self#?fuseaction=member.emptypopup_consumer_req_type_upd&consumer_id=#attributes.consumer_id#" method="post" name="REQ">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57907.Yetkinlik'></th>
					<th><cf_get_lang dictionary_id='58693.Seç'></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="get_req">
					<tr>
						<td>#get_req.REQ_NAME#</td>
						<td width="20">
						<input type="checkbox" name="REQ" id="REQ" value="#get_req.REQ_ID#"<cfif liste contains REQ_ID>checked</cfif>>
						</td>
					</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
		<cf_box_footer><cf_workcube_buttons type_format='1' is_upd='0'></cf_box_footer>
	</cfform>
</cf_box>
