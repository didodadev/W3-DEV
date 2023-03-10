<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfif isdefined("attributes.is_submit")>	
	<cfquery name="get_kesinti" datasource="#dsn#">
		SELECT 
			SO.*
		FROM 
			SETUP_PAYMENT_INTERRUPTION SO
		WHERE 
			SO.IS_ODENEK = 0 AND
            ISNULL(SO.IS_BES,0) = 0
			<cfif len(attributes.keyword)> 
				AND SO.COMMENT_PAY LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			</cfif>
			<cfif isDefined("attributes.status") and len(attributes.status)>
				AND STATUS = #attributes.status#
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_kesinti.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_kesinti.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=ehesap.list_kesinti" method="post" name="filter_list_kesinti">
            <input type="hidden" name="is_submit" id="is_submit" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
                    <cfinput type="text" name="keyword" style="width:100px;" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <select name="status" id="status">
                        <option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
                        <option value="1" <cfif isDefined("attributes.status") and (attributes.status eq 1)> selected</cfif>><cf_get_lang dictionary_id ='57493.Aktif'></option>
                        <option value="0" <cfif isDefined("attributes.status") and (attributes.status eq 0)> selected</cfif>><cf_get_lang dictionary_id ='57494.Pasif'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">  
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='53273.Kesinti Tanımları'></cfsavecontent>
    <cf_box title="#title#" uidrop="1" hide_table_column="1">
        <cf_flat_list> 
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='58233.Tanım'></th>
                    <th><cf_get_lang dictionary_id='53132.Başlangıç Ay'></th>
                    <th><cf_get_lang dictionary_id='53133.Bitiş Ay'></th>
                    <th><cf_get_lang dictionary_id='29472.Yöntem'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=ehesap.list_kesinti&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_kesinti.recordcount>
                    <cfoutput QUERY="get_kesinti" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td align="center">#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=ehesap.list_kesinti&event=upd&odkes_id=#ODKES_ID#" target="_blank">#comment_pay#</a></td>
                            <td>#LISTgetat(ay_list(),start_SAL_MON,',')#</td>
                            <td>#LISTgetat(ay_list(),END_SAL_MON,',')#</td>
                            <td>
                                <cfif get_kesinti.METHOD_PAY EQ 1>
                                    <cf_get_lang dictionary_id='53134.Eksi'>
                                    <cfelseif get_kesinti.METHOD_PAY EQ 2>
                                        <cf_get_lang dictionary_id="53514.Yüzde Ay">
                                    <cfelseif get_kesinti.METHOD_PAY EQ 3>
                                        <cf_get_lang dictionary_id="53518.Yüzde Gün">
                                    <cfelseif get_kesinti.METHOD_PAY EQ 4>
                                        <cf_get_lang dictionary_id="53522.Yüzde Saat">
                                    <cfelseif get_kesinti.METHOD_PAY EQ 5>
                                        <cf_get_lang dictionary_id="53530.Yüzde Kazanç">
                                </cfif>
                            </td>
                            <td style="text-align:right;">#TLFormat(amount_pay)#</td>
                            <td>#money#</td>
                            <!-- sil -->
                            <td style="text-align:center;"><a href="#request.self#?fuseaction=ehesap.list_kesinti&event=upd&odkes_id=#ODKES_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="8"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list> 
        <cfset url_str = "">
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined("attributes.sal_year") and len(attributes.sal_year)>
            <cfset url_str = "#url_str#&sal_year=#attributes.sal_year#">
        </cfif>
        <cfif isdefined("attributes.is_submit") and len(attributes.is_submit)>
            <cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
        </cfif>
        <cfif isdefined("attributes.status") and len(attributes.status)>
            <cfset url_str = "#url_str#&status=#attributes.status#">
        </cfif>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="ehesap.list_kesinti#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
    document.getElementById('keyword').focus();
</script>
