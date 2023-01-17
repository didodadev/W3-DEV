<!--- Liste grup birleştime --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfset select_list="">
<cfset account_list="">
<cfset process_cat=ArrayNew(1)>
<cfquery name="process_bills_group" datasource="#dsn3#">
    SELECT 
    	PROCESS_TYPE_GROUP_ID,
    	PROCESS_NAME,
    	PROCESS_TYPE
    FROM  
    	BILLS_PROCESS_GROUP
    <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
        WHERE
    	    PROCESS_NAME LIKE '%#attributes.keyword#%'
	</cfif>
</cfquery>
<cfoutput query="process_bills_group">
    <cfquery name="process_bills_type_list" datasource="#dsn3#">
        SELECT
        	PROCESS_CAT,
            IS_ACCOUNT
        FROM 
        	SETUP_PROCESS_CAT 
        WHERE 
        	PROCESS_CAT_ID IN (#process_bills_group.process_type#)
        ORDER BY
        	PROCESS_CAT_ID
    </cfquery>
   <cfloop query="process_bills_type_list">
   		<cfset select_list=listappend(select_list,process_bills_type_list.process_cat,',')>
    </cfloop>
    <cfset ArrayAppend(process_cat,select_list)>  
    <cfset select_list="">
</cfoutput>
<cfparam name="attributes.totalrecords" default="0">
<cfif isdefined("attributes.form_submitted")>
	<cfset attributes.totalrecords = process_bills_group.recordcount>
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="pause_type" method="post" action="#request.self#?fuseaction=account.list_bills_process_groups">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(12,'Fiş Birleştime İşlem Grupları',47274)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th> 
					<th><cf_get_lang dictionary_id='47302.İşlem Grup Adı'></th>
					<th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center">
						<a href="javascript://" Onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.list_bills_process_groups&event=add</cfoutput>','medium');"> 
							<i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
						</a> 
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.form_submitted") and process_bills_group.recordcount>
					<cfoutput query="process_bills_group" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr <cfif listfind(account_list,process_type_group_id,',')>style="color:red"</cfif>>
							<td>#currentrow#</td>
							<td>#process_name#</td>
							<td>#process_cat[currentrow]#</td>
							<!-- sil -->
							<td style="text-align:center;">
								<a href="javascript://" Onclick="windowopen('#request.self#?fuseaction=account.list_bills_process_groups&event=upd&id=#PROCESS_TYPE_GROUP_ID#','medium');">
									<i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>
								</a>
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
						<tr>
							<td colspan="4"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
						</tr>
				</cfif> 
			</tbody>
		</cf_flat_list>

		<cfset adres = 'account.list_bills_process_groups'>
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
			<cfset adres = adres&'&keyword=#attributes.keyword#'>
		</cfif>
		<cf_paging page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#adres#&form_submitted=1">
	</cf_box>
</div>
<script>
	document.getElementById('keyword').focus();
</script>
