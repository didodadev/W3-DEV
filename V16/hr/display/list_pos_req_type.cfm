<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfscript>
    get_pos_req_types.recordcount = 0;
    get_pos_req_types.query_count = 0;

	attributes.startrow = ((attributes.page - 1) * attributes.maxrows) + 1;
	if (isdefined("attributes.form_submitted"))
	{
		cmp_pos_req_type = createObject("component","V16.hr.cfc.get_pos_req_types");
		cmp_pos_req_type.dsn = dsn;
		get_pos_req_types = cmp_pos_req_type.get_pos_req_type(
			keyword: attributes.keyword,
			maxrows: attributes.maxrows,
			startrow: attributes.startrow
		);
	}
	else
		get_pos_req_types.query_count = 0;
		
	if (fuseaction contains "popup")
		is_popup = 1;
	else
		is_popup = 0;
		
	url_str = '';
	if (isdefined("attributes.keyword") and len(attributes.keyword))
		url_str = '#url_str#&keyword=#attributes.keyword#';
	if (isdefined("attributes.form_submitted") and len(attributes.form_submitted))
		url_str = '#url_str#&form_submitted=#attributes.form_submitted#';
</cfscript>

<cfparam name="attributes.totalrecords" default="#get_pos_req_types.query_count#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=hr.list_position_req_type" method="post" name="search">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="55214.Yeterlilik Tanımları"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_flat_list> 
            <thead>
                <tr>
                    <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57907.Yetkinlik'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57571.Ünvan'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center">
                        <!--- <a href="JAVASCRIPT://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_add_pos_req_type</cfoutput>','small')"><img src="/images/plus_square.gif" border="0"></a> --->
                        <a href="<cfoutput>#request.self#?fuseaction=hr.list_position_req_type&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                    </th>
                    <!-- sil -->        
                </tr>
            </thead>
            <tbody>
                <cfif get_pos_req_types.recordcount>
                    <cfoutput query="get_pos_req_types">
                        <tr>
                            <td align="center" width="35">#rownum#</td>				   
                            <td width="200">#req_type#</td>  		  
                            <td width="150">#employee_name# #employee_surname#</td>
                            <td width="100">#dateformat(record_date,dateformat_style)#</td>
                            <td>#titles#</td>
                            <!-- sil -->
                            <td style="text-align:center;"> 
                            <!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_upd_pos_req_type&REQ_TYPE_ID=#REQ_TYPE_ID#','small')"><img src="/images/update_list.gif" border="0"></a> --->
                                <a href="#request.self#?fuseaction=hr.list_position_req_type&event=upd&req_type_id=#req_type_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>			 
                            </td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>

        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="hr.list_position_req_type#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
