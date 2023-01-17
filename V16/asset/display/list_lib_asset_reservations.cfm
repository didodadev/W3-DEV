<cfquery name="get_lib_detail" datasource="#dsn#">
	SELECT
		LIB_ASSET_NAME
	FROM
	LIBRARY_ASSET
	WHERE LIB_ASSET_ID = #attributes.lib_asset_id# 
</cfquery>

<cfparam name="attributes.keyword" default="">
<cfinclude template="../query/get_lib_asset_reserve.cfm">
<cfif get_lib_asset_info.recordcount>
	<cfif len(get_lib_asset_info.startdate)>
		<cfset startdate = date_add('h', session.ep.time_zone, get_lib_asset_info.startdate)>
	</cfif>
	<cfif len(get_lib_asset_info.finishdate)>
		<cfset finishdate = date_add('h', session.ep.time_zone, get_lib_asset_info.finishdate)>
	</cfif>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_lib_asset_info.recordcount#">
<cfinclude template="../query/get_last_date_info.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    
    <cf_box popup_box="1" title="#getLang('','Tarihçe','57473')#: #get_lib_detail.lib_asset_name#" uidrop="1" add_href="javascript:openBoxDraggable('#request.self#?fuseaction=asset.popup_form_lib_asset_rezerve&lib_asset_id=#attributes.lib_asset_id#&status=2&startdate=#GET_LAST_DATE_INFO.MAX_DATE#')">
        <cfform name="search" action="#request.self#?fuseaction=asset.popup_list_lib_asset_reservations" method="post">
            <cf_box_search>
                <cfinput type="hidden" name="lib_asset_id" value="#attributes.lib_asset_id#">
                    <div class="form-group">
                        <cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre Ediniz','57701')#">
                    </div>
                    <div class="form-group small">
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı!','57537')#" maxlength="3" style="width:25px;">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4" search_function="loadPopupBox('search' ,  #attributes.modal_id#)">
                    </div>
            </cf_box_search>
        </cfform>
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='47783.Okuyucu'></th>
                    <th width="90"><cf_get_lang dictionary_id='47784.Aldığı/Alacağı Tarih'></th>
                    <th width="90"><cf_get_lang dictionary_id='47785.Vermesi Gereken Tarih'></th>
                    <th width="100"><cf_get_lang dictionary_id='47786.Geri Verdiği/İptal Tarih'></th>
                    <th width="55" class="text-center"><i class="fa fa-pencil"></i></th>
                    <th class="text-center"><i class="icon-check"></i></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_lib_asset_info.recordcount>
                <cfoutput query="get_lib_asset_info" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <tr  onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';">
                        <td>#get_emp_info(get_lib_asset_info.emp_id,0,1)#</td>
                        <td>#dateformat(startdate,dateformat_style)#&nbsp;#timeformat(startdate,timeformat_style)#</td>
                        <td>#dateformat(finishdate,dateformat_style)#&nbsp;#timeformat(finishdate,timeformat_style)#</td>
                        <td><cfif (status eq 0) or (status eq 2)>
                                &nbsp;
                            <cfelse>
                                <cfif len(return_date)>
                                    #dateformat(return_date,dateformat_style)#&nbsp;#timeformat(dateadd('h',session.ep.time_zone,return_date),timeformat_style)# 
                                </cfif>
                            </cfif>
                        </td>
                        <td>
                            <cfsavecontent variable="ty_message"><cf_get_lang dictionary_id='47850.Şu an kitabın teslim edildiğini onaylıyorsunuz.Emin misiniz'>?</cfsavecontent>
                            <cfif status eq 0>
                                <a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=asset.popup_form_upd_lib_asset_reserve&lib_asset_id=#library_asset_id#&reserve_id=#library_reserve_id#&status=3','small');"><i class="fa fa-pencil" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>"></i></a>
                            <cfelseif status eq 2>
                                <a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=asset.popup_form_upd_lib_asset_reserve&lib_asset_id=#library_asset_id#&reserve_id=#library_reserve_id#&status=3','small');"><i class="fa fa-pencil" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>"></i></a>
                            <cfelseif status eq 3>
                                <a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=asset.popup_form_upd_lib_asset_reserve&lib_asset_id=#library_asset_id#&reserve_id=#library_reserve_id#&status=3','small');"><i class="fa fa-pencil" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>"></i></a>
                            </cfif>
                        </td>
                        <td class="text-center">
                            <cfif status eq 0>
                                <a href="#request.self#?fuseaction=asset.emptypopup_upd_lib_asset_reserve&lib_asset_id=#library_asset_id#" onClick="if(confirm('#ty_message#')) return true; else return false;"><i class="icon-check" alt="<cf_get_lang no='17.Teslim Edildi'>" title="<cf_get_lang no='17.Teslim Edildi'>"></i></a>
                            <cfelseif status eq 2>
                                <label ><cf_get_lang dictionary_id='47696.Beklemede'></label>
                            <cfelseif status eq 3>
                                <a href="#request.self#?fuseaction=asset.popup_form_upd_lib_asset_reserve&lib_asset_id=#library_asset_id#&reserve_id=#library_reserve_id#&status=3&fromlist"><i class="icon-check" style="color:red!important;" alt="<cf_get_lang no='27.Teslim Aldı'>" title="<cf_get_lang no='27.Teslim Aldı'>"></i></a>
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cf_box_footer>
            <cfif attributes.totalrecords gt attributes.maxrows>
                <cf_paging 
                 page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="asset.popup_list_lib_asset_reservations&lib_asset_id=#attributes.lib_asset_id#&keyword=#attributes.keyword#">
            </cfif>
        </cf_box_footer>
    </cf_box>
</div>

<script type="text/javascript">
function close_frame()
{
	wrk_opener_reload();
	window.close();
}
</script>
