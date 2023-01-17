<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
    <cfquery name="get_zimmet" datasource="#dsn#">
        SELECT 
            EI.*,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME ,
            E.EMPLOYEE_ID
        FROM 
            EMPLOYEES_INVENT_ZIMMET EI,
            EMPLOYEES E
        WHERE
            E.EMPLOYEE_ID=EI.EMPLOYEE_ID AND
            EI.COMPANY_ID = #session.ep.company_id# AND
            (E.EMPLOYEE_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
    </cfquery>
<cfelse>
	<cfset get_zimmet.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_zimmet.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_zimmet" method="post" action="#request.self#?fuseaction=assetcare.list_inventory_zimmet">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#place#" value="#attributes.keyword#" maxlength="50" style="width:100px;">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(657,'Zimmet Kayıtları',48528)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='48531.Zimmet Alan'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=assetcare.popup_form_add_zimmet</cfoutput>')"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_zimmet.recordcount>
					<cfoutput query="get_zimmet"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="35">#currentrow#</td>
							<td><a href="javascript://"  onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMPLOYEE_ID#');" class="tableyazi"> 
								#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
							<!-- sil -->
							<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=assetcare.popup_form_upd_zimmet&zimmet_id=#ZIMMET_ID#')"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_str = "">
		<cfif isdefined("attributes.keyword")>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="assetcare.list_inventory_zimmet#url_str#">
	</cf_box>
</div>

<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
