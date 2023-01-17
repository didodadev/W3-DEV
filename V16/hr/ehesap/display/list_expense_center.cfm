<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.form_exist" default="0">
<cfif fusebox.use_period eq true>
    <cfset dsn_expense = dsn2>
<cfelse>
    <cfset dsn_expense = dsn>
</cfif>
<cfif attributes.form_exist>
	<cfquery name="GET_EXPENSE" datasource="#dsn_expense#">
		SELECT
			*
		FROM
			EXPENSE_CENTER
		WHERE	
			EXPENSE_ID IS NOT NULL
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND EXPENSE LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				DETAIL LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				EXPENSE_CODE LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI 
			</cfif>
			<cfif len(attributes.process_type) and attributes.process_type eq 1>
			AND EXPENSE_ACTIVE = 1
			<cfelseif len(attributes.process_type) and attributes.process_type eq 0>
			AND EXPENSE_ACTIVE = 0
		   </cfif>
		ORDER BY
			EXPENSE_CODE
	</cfquery>
<cfelse>
	<cfset get_expense.recordcount=0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_expense.recordcount#'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form_search" action="#request.self#?fuseaction=ehesap.list_expense_center" method="post">
            <input type="hidden" name="form_exist" id="form_exist" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
                    <cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <select name="process_type" id="process_type" style="width:60px;">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1" <cfif attributes.process_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif attributes.process_type eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>												
                    </select>
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
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="54256.Masraf Merkezleri"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_flat_list>     
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='54257.Kodu'></th>
                    <th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center"><a href="javascript:openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_expense_center&event=add','small');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='54259.Alt Hesap Ekle'>" alt="<cf_get_lang dictionary_id='54259.Alt Hesap Ekle'>"></i></a></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_expense.recordcount>
                    <cfoutput query="get_expense" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#get_expense.currentrow#</td>
                            <td>#EXPENSE_CODE#</td>
                            <td>
                                <cfif ListLen(EXPENSE_CODE,".") neq 1>
                                    <cfloop from="1" to="#ListLen(EXPENSE_CODE,".")#" index="i">
                                        
                                    </cfloop>
                                </cfif>
                                <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_expense_center&event=upd&obj=1&expense_id=#expense_id#','medium');">#EXPENSE#</a></td>
                            <td>#DETAIL#</td>
                            <!-- sil -->
                            <td style="text-align:center;"> 
                                <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_expense_center&event=upd&obj=1&expense_id=#expense_id#','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                            </td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <cfif attributes.form_exist>
                            <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                        <cfelse>
                            <td colspan="5"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
                        </cfif>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>  
        <cfset url_str = ''>   
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            <cfset url_str = '#url_str#&keyword=#attributes.keyword#'>
        </cfif>
        <cfif isdefined("attributes.form_exist") and len(attributes.form_exist)>
            <cfset url_str = '#url_str#&form_exist=#attributes.form_exist#'>
        </cfif>
        <cfif isdefined("attributes.process_type") and len(attributes.process_type)>
            <cfset url_str = '#url_str#&process_type=#attributes.process_type#'>
        </cfif>
        <cf_paging
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="ehesap.list_expense_center#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
    document.getElementById('keyword').focus();
</script>
