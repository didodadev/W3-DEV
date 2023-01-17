<cfsetting showdebugoutput="no">
<cfquery name="get_app" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_POS WHERE APP_POS_ID=#attributes.app_pos_id#
</cfquery>
<cfquery name="get_app_pos" datasource="#dsn#">
		SELECT * 
		FROM 
			EMPLOYEES_APP_POS 
		WHERE 
			EMPAPP_ID=#get_app.empapp_id# AND 
			APP_POS_ID <> #attributes.app_pos_id#
</cfquery>

<cf_flat_list>
	<thead>
		<tr>
			<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='55247.Başvuru No'></th>
				<th><cf_get_lang dictionary_id='55159.İlan'></th>
			<th><cf_get_lang dictionary_id='57756.Durum'></th>
			<th><cf_get_lang dictionary_id='57742.Tarih'></th>
			<th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
			<th  width="30"><a><i class="fa fa-pencil" border="0"></i></a></th>
		</tr>
	</thead>
	<tbody>
	<cfif get_app_pos.recordcount>
		<cfoutput query="get_app_pos">
			<cfif len(POSITION_CAT_ID)>
				<cfset attributes.position_cat_id = get_app_pos.POSITION_CAT_ID>
				<cfinclude template="../query/get_position_cat.cfm">
				<cfset position_cat = "#GET_POSITION_CAT.POSITION_CAT#">
			<cfelse>
				<cfset attributes.position_cat_id = "">
				<cfset position_cat = "">
			</cfif>
			<cfif len(get_app_pos.notice_id)>
				<cfquery name="GET_NOTICES" datasource="#DSN#">
					SELECT NOTICE_HEAD,NOTICE_NO,STATUS FROM NOTICES WHERE NOTICE_ID=#get_app_pos.notice_id# 
				</cfquery>
				<cfset notice = "#GET_NOTICES.notice_no#-#GET_NOTICES.notice_head#">
			<cfelse>
				<cfset notice = "">
			</cfif>
			<tr>
				<td  width="30">#currentrow#</td>
				<td>#get_app_pos.app_pos_id#</td>
				<td><a href="#request.self#?fuseaction=hr.apps&event=upd&empapp_id=#get_app.empapp_id#&app_pos_id=#app_pos_id#" class="tableyazi">#notice#</a>
				</td>
				<td><cfif get_app_pos.app_pos_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
				<td>#DateFormat(get_app_pos.app_date,dateformat_style)#</td>
				<td>#position_cat#</td>
				<td width="30"><a href="#request.self#?fuseaction=hr.apps&event=upd&empapp_id=#get_app.empapp_id#&app_pos_id=#app_pos_id#"><i
				class="fa fa-pencil" border="0"></i></a></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tr>
	</cfif>
    </tbody>
</cf_flat_list>

