<cfquery name="GET_ALL" datasource="#DSN#">
	SELECT 
		FAVORITE_NAME,
        FAVORITE_SHORTCUT_KEY,
        FAVORITE_ID,
        FAVORITE
	FROM 
		FAVORITES 
	WHERE 
		EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	ORDER BY 
    	FAVORITE_NAME
</cfquery>
<table class="ajax_list">
    <thead>
        <tr>      
            <th><cf_get_lang_main no='12.oncelikli menu'></th>
            <th><cf_get_lang no ='749.Kısayol'></th>                       
            <th style="width:20px;">
                <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=myhome.popup_favorites&self=1&act=#attributes.act#</cfoutput>')">
                    <i class="fa fa-plus"></i>
                </a>
            </th>
        </tr>  
    </thead> 
    <cfif get_all.recordcount>
		<cfoutput query="get_all">
            <tr id="Fav_#favorite_id#">
                <td><abbr title="?fuseaction=#favorite#">#favorite_name#</abbr></td>
                <td><kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>#favorite_shortcut_key#</kbd></td>                       
                <td style="width:20px;">
                    <a href="javascript://" onClick="if(confirm('#getLang("myhome",866,"İlgili kaydı silmek istediğnizden emin misiniz")#')) {AjaxPageLoad('#request.self#?fuseaction=myhome.emptypopup_add_favorites&del=#favorite_id#','FAV_INFO',0,'Siliniyor',0,0,1);gizle(Fav_#favorite_id#);} else return false;">
                        <i class="fa fa-minus"></i>
                    </a>
                </td>
            </tr>
         </cfoutput>
    <cfelse>
        <tr>
            <td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
        </tr>
    </cfif>
</table>    
<div style="display:none;" id="FAV_INFO"></div> 


