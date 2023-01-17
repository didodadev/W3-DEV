<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.is_submit")>
<cfquery name="GET_ANNOUNCE" datasource="#dsn#">
	SELECT
		TCA.ANNOUNCE_HEAD,
		TCA.START_DATE,
		TCA.FINISH_DATE,
		TCA.ANNOUNCE_ID
	FROM
		TRAINING_CLASS_ANNOUNCEMENTS TCA,
		TRAINING_CLASS_ANNOUNCE_ATTS TCAA
	WHERE
		TCA.ANNOUNCE_ID = TCAA.ANNOUNCE_ID AND
		TCAA.EMPLOYEE_ID = #session.ep.userid# AND
		TCA.START_DATE <= #now()# AND
		TCA.FINISH_DATE >= #now()#
</cfquery>
<cfelse>
	<cfset get_announce.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_announce.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form1" method="post" action="#request.self#?fuseaction=training.list_class_announce">
<input type="hidden" name="is_submit" id="is_submit" value="1">
<cf_big_list_search title="#getLang('training',114)#"> 
	<cf_big_list_search_area>
		<table>
			<tr> 
				<td><cf_get_lang_main no='48.Filtre'></td>
				<td><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" style="width:100px;" maxlength="50"></td>
				<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;"></td>
				<td><cf_wrk_search_button></td>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
			</tr>
		</table>
	</cf_big_list_search_area>
</cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang_main no='1165.Sıra'></th>
			<th><cf_get_lang_main no ='68.Başlık'></th>
			<th width="200"><cf_get_lang no ='181.Duyuru Tarihi'></th>
			<th class="header_icn_none"></th>
		</tr>
	</thead>
	<tbody>
		<cfif GET_ANNOUNCE.recordcount>
			<cfoutput query="GET_ANNOUNCE" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
				<tr>
					<td>#currentrow#</td>
					<td>#ANNOUNCE_HEAD#</td>
					<td>#dateformat(START_DATE,dateformat_style)#-#dateformat(FINISH_DATE,dateformat_style)#</td>
					<!-- sil -->
					<td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_upd_announce_req&announce_id=#ANNOUNCE_ID#','medium');" ><img src="/images/update_list.gif"  title="Ayrıntılar"></a></td>
					<!-- sil -->
				</tr>
			</cfoutput> 
		<cfelse>
			<tr> 
				<td colspan="8"><cfif isdefined("attributes.is_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfset adres = "training.list_class_announce">
<cfif len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.is_submit") and len(attributes.is_submit)>
	<cfset adres = "#adres#&is_submit=#attributes.is_submit#">
</cfif>
<cf_paging 
    page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#adres#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
