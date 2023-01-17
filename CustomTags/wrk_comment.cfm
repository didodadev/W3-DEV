<cfparam name="attributes.action_id" default="">
<cfparam name="attributes.table_name" default="">
<cfparam name="attributes.data_source" default="">
<cfparam name="attributes.col_name" default="">
<cfparam name="attributes.col_id" default="">
<cfparam name="attributes.col_comment_id" default="">
<cfset comm_url_info ="&action_id=#attributes.action_id#&table_name=#attributes.table_name#&data_source=#attributes.data_source#&col_name=#attributes.col_name#&col_id=#attributes.col_id#&col_comment_id=#attributes.col_comment_id#">
<!--- Yorumlar --->
<table cellspacing="1" cellpadding="2" width="99%" border="0" class="color-border">
    <tr class="color-header" height="20">
        <td>
            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="1%">
                        <img src="/images/listele_down.gif"  border="0" align="absmiddle" id="comment_down_img" style="display:none;cursor:pointer;" onclick="gizle_goster(show_ct_comment);gizle_goster_img('comment_down_img','comment_img','show_comment');">
                        <img src="/images/listele.gif"  border="0" align="absmiddle"  id="comment_img" style="display:;cursor:pointer;" onclick="gizle_goster(show_ct_comment);gizle_goster_img('comment_down_img','comment_img','show_comment');AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.list_comment#comm_url_info#</cfoutput>','show_comment',1);">
                     </td>
                     <td  width="5" class="form-title"><cfoutput>#caller.getLang('main',773)#</cfoutput></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id="show_ct_comment" class="color-row" style="display:none;">
        <td><div id="show_comment" style="overflow:scroll; display:none;height:200;"></div></td>
    </tr>
</table>

