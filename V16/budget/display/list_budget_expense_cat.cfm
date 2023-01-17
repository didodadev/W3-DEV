<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.kategory_secim" default="">
<cfparam name="attributes.form_exist" default="0">
<cfif attributes.form_exist>
	<cfinclude template="../query/get_expense_cat_list.cfm">
<cfelse>
	<cfset get_expense_cat_list.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_expense_cat_list.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" method="post" action="#request.self#?fuseaction=budget.list_expense_cat">
            <input type="hidden" name="form_exist" id="form_exist" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <cfsavecontent variable="placeholder"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
                    <cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#placeholder#">
                </div>
                <div class="form-group">
                    <select name="kategory_secim" id="kategory_secim" style="width:100px;">
                        <option value=""><cf_get_lang dictionary_id='58460.Masraf Merkezi'></option>
                        <option value="ik" <cfif attributes.kategory_secim is 'ik'>selected</cfif>><cf_get_lang dictionary_id='29661.HR'></option>
                        <option value="eg" <cfif attributes.kategory_secim is 'eg'>selected</cfif>><cf_get_lang dictionary_id='57419.Eğitim'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" onKeyUp="isNumber (this)" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='49125.Bütçe Kategorileri'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id="57559.Bütçe"><cf_get_lang dictionary_id="49181.Kodu"></th>
                    <th><cf_get_lang dictionary_id='57486.kategori'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#?fuseaction=budget.list_expense_cat&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_expense_cat_list.recordcount>
                    <cfoutput query="get_expense_cat_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#expense_cat_code#</td>
                            <td> <cfif ListLen(expense_cat_code,".") neq 1>
                            <cfloop from="1" to="#ListLen(expense_cat_code,".")#" index="i">
                            &nbsp;
                            </cfloop>
                            </cfif>
                            #expense_cat_name#</td>
                            <td>#expense_cat_detail#</td>
                            <!-- sil -->
                            <td align="center"><a href="#request.self#?fuseaction=budget.list_expense_cat&event=upd&cat_id=#expense_cat_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr><td colspan="7"><cfif attributes.form_exist> <cf_get_lang dictionary_id='57484.Kayıt Yok'>! <cfelse> <cf_get_lang dictionary_id='57701.Filtre Ediniz'>! </cfif> </td> </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    
        <cfset url_str ="">
        <cfif isdefined ("attributes.keyword") and len (attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined ("attributes.form_exist") and len (attributes.form_exist)>
            <cfset url_str = "#url_str#&form_exist=#attributes.form_exist#">
        </cfif>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="budget.list_expense_cat#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.form.keyword.focus();
</script>
