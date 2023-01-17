<cfsetting showdebugoutput="no">
<cfquery name="get_hobby" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_HOBBY
	ORDER BY 
		HOBBY_NAME ASC
</cfquery>
<cfquery name="get_consumer_hobbies" datasource="#dsn#"> 
	SELECT HOBBY_ID FROM CONSUMER_HOBBY WHERE CONSUMER_ID = #attributes.consumer_id#
</cfquery>
<cfset liste = valuelist(get_consumer_hobbies.hobby_id)>
<cf_box title="#getLAng('','Hobiler','30648')#" popup_box="1">
	<cfform name="hobby" method="post" action="#request.self#?fuseaction=member.emptypopup_consumer_hobbies_upd&consumer_id=#attributes.consumer_id#">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='30509.Hobi'></th>
					<th><cf_get_lang dictionary_id='58693.Seç'></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="get_hobby">
					<tr>
						<td>#get_hobby.HOBBY_NAME#</td>
						<td width="20">
							<input type="checkbox" name="HOBBY" id="HOBBY" value="#get_hobby.HOBBY_ID#"<cfif liste contains HOBBY_ID>checked</cfif>>
						</td>
					</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
		<cf_box_footer><cf_workcube_buttons type_format='1' is_upd='0'></cf_box_footer>
	</cfform>
</cf_box>
