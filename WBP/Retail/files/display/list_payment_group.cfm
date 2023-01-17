<cfquery name="Get_Payment_Group" datasource="#dsn_dev#">
	SELECT PAYMENT_GROUP_ID,PAYMENT_GROUP_NAME FROM PAYMENT_GROUP
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="header_"><cf_get_lang dictionary_id='61784.Ödeme Grupları'></cfsavecontent> 
	<cf_box title="#header_#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58969.Grup Adı'></th>
					<th width="25" class="nohover"></th>
					<th width="20"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.list_payment_group&event=add</cfoutput>','list');"><i class="fa fa-plus"></i></a></th>
				</tr> 
			</thead>
			<tbody>
				<cfif Get_Payment_Group.Recordcount>
					<cfoutput query="Get_Payment_Group">
						<tr>
						<td width="50">#CurrentRow#</td>
						<td>#Payment_Group_Name#</td>
						<td width="25"><a href="#request.self#?fuseaction=retail.list_payment_group&event=upd&group_id=#payment_group_id#&is_form_submitted=1"><img src="/images/update_list.gif" /></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
					<td colspan="4"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'></cfif></td>            
					</tr>
				</cfif>
			</tbody>       
		</cf_grid_list>
	</cf_box>
</div>