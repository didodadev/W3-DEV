<cfparam name="attributes.keyword" default="">
<cfquery name="GET_LIB_ASSET_INFO" datasource="#dsn#">
	SELECT 
		LAR.* ,
		LA.LIB_ASSET_NAME
	FROM 
		LIBRARY_ASSET_RESERVE AS LAR,
		LIBRARY_ASSET AS LA
	WHERE	
		LAR.STATUS in (0,3)
		AND
		LAR.LIBRARY_ASSET_ID = LA.LIB_ASSET_ID
		<cfif len(attributes.keyword) and len(attributes.keyword) eq 1>
			AND LA.LIB_ASSET_NAME LIKE '#attributes.keyword#%'
		<cfelseif len(attributes.keyword) and len(attributes.keyword) gt 1>
			AND LA.LIB_ASSET_NAME LIKE '%#attributes.keyword#%'
		</cfif>
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_LIB_ASSET_INFO.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif len(get_lib_asset_info.startdate) and len(get_lib_asset_info.finishdate)>
	<cfset startdate = date_add('h', session.ep.time_zone, get_lib_asset_info.startdate)>
	<cfset finishdate = date_add('h', session.ep.time_zone, get_lib_asset_info.finishdate)>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box popup_box="1" title="#getLang('','Rezervasyonlar','47678')#" uidrop="1">
        <cfform name="search" action="#request.self#?fuseaction=asset.popup_list_lib_book_rezervation" method="post">
            <cf_box_search more="0">
                <div class="form-group">
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre Ediniz','57701')#">
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı!','57537')#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="loadPopupBox('search' , #attributes.modal_id#)">
                </div>
            </cf_box_search>
        </cfform>
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="150"><cf_get_lang dictionary_id='47793.Kitap Adı'></th>
                    <th class="form-title"><cf_get_lang dictionary_id='47783.Okuyucu'></th>
                    <th width="85"><cf_get_lang dictionary_id='47784.Aldığı/Alacağı Tarih'></th>
                    <th width="85"><cf_get_lang dictionary_id='47785.Vermesi Gereken Tarih'></th>
                    <th width="85"><cf_get_lang dictionary_id='47673.Geri Verdiği Tarih'></th>
                    <th width="18">&nbsp;</th>
                </tr>
            </thead>
            <tbody>
                <cfif GET_LIB_ASSET_INFO.recordcount>
                    <cfoutput query="GET_LIB_ASSET_INFO" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                        <tr>
                            <td>#GET_LIB_ASSET_INFO.LIB_ASSET_NAME#</td>
                            <td>#GET_EMP_INFO(GET_LIB_ASSET_INFO.EMP_ID,0,1)#</td>
                            <td> #dateformat(STARTDATE,"dd/mm/yy")#&nbsp;#TIMEFORMAT(STARTDATE,timeformat_style)# </td>
                            <td>
                                <cfif STATUS EQ 0>
                                    #dateformat(FINISHDATE,"dd/mm/yy")#&nbsp;#TIMEFORMAT(FINISHDATE,timeformat_style)#
                                <cfelse>
                                    #dateformat(RETURN_DATE,"dd/mm/yy")#&nbsp;#TIMEFORMAT(RETURN_DATE,timeformat_style)#
                                </cfif>
                            </td>
                            <td>
                                <cfif STATUS EQ 1>
                                    #dateformat(FINISHDATE,"dd/mm/yy")#&nbsp;#TIMEFORMAT(FINISHDATE,timeformat_style)#
                                <cfelse>
                                    #dateformat(RETURN_DATE,"dd/mm/yy")#&nbsp;#TIMEFORMAT(RETURN_DATE,timeformat_style)#
                                </cfif>
                            </td>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='47850.Şu an kitabın teslim edildiğini onaylıyorsunuz.Emin misiniz'></cfsavecontent>
                            <td><a href="javascript://" onClick="if(confirm('#message#')) windowopen('#request.self#?fuseaction=asset.emptypopup_upd_lib_asset_reserve&lib_asset_id=#LIBRARY_ASSET_ID#','medium');else return false;"><i class="fa fa-flag-checkered" style="color:green" alt="<cf_get_lang dictionary_id='47688.Teslim Edildi'>"></i></a></td>
                        </tr>
                    </cfoutput>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif GET_LIB_ASSET_INFO.recordcount eq 0>
            <div class="ui-info-bottom">
                <p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</p>
            </div>
        </cfif>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cf_paging page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="asset.popup_list_lib_book_rezervation&keyword=#attributes.keyword#"> </td>
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
