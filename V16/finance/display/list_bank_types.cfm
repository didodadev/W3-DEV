<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_BANK_TYPES" datasource="#DSN#">
		SELECT 
			*,
            SETUP_BANK_TYPE_GROUPS.BANK_TYPE
		FROM 
			SETUP_BANK_TYPES LEFT JOIN SETUP_BANK_TYPE_GROUPS ON SETUP_BANK_TYPES.BANK_TYPE_GROUP_ID = SETUP_BANK_TYPE_GROUPS.BANK_TYPE_ID
		WHERE 
			BANK_ID IS NOT NULL 
			<cfif len(attributes.keyword)>
				AND 
				(BANK_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				 BANK_CODE LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
			</cfif>
		ORDER BY
			BANK_NAME
	</cfquery>
<cfelse>
	<cfset get_bank_types.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_bank_types.recordcount#">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" action="#request.self#?fuseaction=#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('finance'))#.list_bank_types" method="post">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search> 
                <div class ="form-group">
                    <cfinput type="text" maxlength="50" name="keyword" value="#attributes.keyword#" placeholder="#getLang('main',48)#">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57987.Bankalar'></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57521.Banka'></th>
                    <th><cf_get_lang dictionary_id='59006.Banka Kodu'></th>
                    <th><cf_get_lang dictionary_id='34102.Banka Tipi'></th>
                    <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <!-- sil -->
                    <th width="20"><cfif not listfindnocase(denied_pages,"#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('finance'))#.popup_add_bank_branch")><i class="icon-branch"></i></cfif></th>
                    <th width="20">
                        <cfif not listfindnocase(denied_pages,"#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('finance'))#.popup_add_bank_type")>
                            <a href="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#</cfoutput>.list_bank_types&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57521.Banka'><cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57521.Banka'><cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                        </cfif>
                    </th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_bank_types.recordcount>
                <cfoutput query="get_bank_types" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td width="20">#currentrow#</td>
                        <td><a href="#request.self#?fuseaction=#fusebox.circuit#.list_bank_types&event=upd&id=#bank_id#" class="tableyazi">#bank_name#</a></td>
                        <td>#bank_code#</td>
                        <td>#BANK_TYPE#</td>
                        <td>#detail#</td>
                        <td>#dateformat(record_date,dateformat_style)#</td>
                        <!-- sil -->
                        <td width="20">
                            <cfif not listfindnocase(denied_pages,"#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('finance'))#.popup_add_bank_branch")>
                                <a href="#request.self#?fuseaction=#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('finance'))#.list_bank_branch&event=add&bank_id=#bank_id#"><i class="icon-branch" alt="<cf_get_lang dictionary_id='52641.Şube Ekle'>" title="<cf_get_lang dictionary_id='52641.Şube Ekle'>"></i></a>
                            </cfif>
                        </td>
                        <td width="20"><a href="#request.self#?fuseaction=#fusebox.circuit#.list_bank_types&event=upd&id=#bank_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='426.Banka Guncelle'>" title="<cf_get_lang dictionary_id='54812.Banka Guncelle'>"></i></a></td>
                        <!-- sil -->
                    </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="9"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfset url_str = "#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('finance'))#.list_bank_types">
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
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
            adres="#url_str#">
    </cf_box>
</div>

<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
