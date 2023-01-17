<cf_form_box title="#getLang('forum',4)#">
  <cfform name="add_topic" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=forum.emptypopup_add_topic">
    <cf_area>
        <table>
            <cfoutput>
                <cfset my_this_row_ = 0>
                <cfset forum_image_mode = 2>
                <cfloop from="1" to="16" index="i">
                <cfset my_this_row_ = my_this_row_ + 1>
                    <cfif my_this_row_ mod forum_image_mode eq 1><tr></cfif>
                    <td align="left">
                        <input type="Radio" value="#i#" name="ImageID" id="ImageID" <cfif i eq 1>checked</cfif>><img src="/forum/images/data/icon#i#.gif" border="0">
                    </td>
                    <cfif my_this_row_ mod forum_image_mode eq 0></tr></cfif>
                </cfloop>
            </cfoutput> 
        </table>
    </cf_area>
    <cf_area>
        <table>
            <tr>
                <td height="20"><cf_get_lang no='65.Forum Adı'>*</td>
                <td><cfinclude template="../query/get_forums.cfm">
                    <select name="forumid" id="forumid" style="width:583px;">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="forums">
                            <option value="#FORUMID#" <cfif FORUMID eq attributes.forumid>selected</cfif>>#FORUMNAME#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='68.Başlık'>*</td>
                <td><cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='68.Başlık'></cfsavecontent>
                    <cfinput type="Text" name="title" style="width:583px;" required="yes" message="#message#" maxlength="150"></td>
            </tr>
            <tr>
                <td colspan="2">
                <cfmodule
                    template="/fckeditor/fckeditor.cfm"
                    toolbarSet="WRKContent"
                    basePath="/fckeditor/"
                    instanceName="topic"
                    valign="top"
                    value=""
                    width="650"
                    height="325">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="Checkbox" name="email_emp" id="email_emp" value="<cfoutput>#session.ep.userid#</cfoutput>"><cf_get_lang no='56.Cevapları Mail Gönder'>&nbsp;
                    <input type="Checkbox" name="locked" id="locked" value="1"><cf_get_lang no='66.Yeni Cevap Kapalı'>&nbsp;
                    <input type="checkbox" name="topic_status" id="topic_status" value="1" checked><cf_get_lang_main no='81.Aktif'>&nbsp;
                    <input type="checkbox" name="email" id="email" value="1"><cf_get_lang no='71.Forum Yöneticisine Mail Gönder'>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='103.Dosya Ekle'></td>
                <td><input type="file" name="attach_topic_file" id="attach_topic_file" style="width:235px;"></td>
            </tr>
        </table>
    </cf_area>
	<cf_form_box_footer><cf_workcube_buttons is_upd='0' type_format="1" add_function='kontrol()'></cf_form_box_footer>
  </cfform>
</cf_form_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.add_topic.forumid.value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='65.Forum Adı'>");
			return false;
		}
	}
</script>
