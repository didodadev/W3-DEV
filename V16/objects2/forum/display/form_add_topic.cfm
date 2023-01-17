<cfinclude template="../../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>

<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%; height:35px;">
  	<tr>
    	<td class="headbold"><cf_get_lang no='985.Konu Ekle'></td>
  	</tr>
</table>

<cfform enctype="multipart/form-data" action="#request.self#?fuseaction=objects2.emptypopup_add_topic" method="post" name="add_topic">
<table cellspacing="0" cellpadding="0" align="center" style="width:98%;">
    <tr class="color-border">
        <td>
      		<table cellspacing="1" cellpadding="2" align="center" style="width:100%;">
        		<tr>
            		<input type="hidden" name="forumid" id="forumid" value="<cfoutput>#attributes.forumid#</cfoutput>">
                    <td class="color-row" style="width:100px; vertical-align:top;">
                        <table>
                            <tr>
                                <td class="txtboldblue"><cf_get_lang no='983.İmge Seçiniz'></td>
                                <cfoutput>
                                <cfloop from="1" to="16" index="i">
                                <tr>
                                <td><input type="radio" value="#i#" name="ImageID" id="ImageID" <cfif i eq 1>checked</cfif>>
                                <img src="/forum/images/data/icon#i#.gif" border="0"></td>
                                </tr>
                                </cfloop>
                                </cfoutput>
                        </table>
                    </td>
                    <td class="color-row" style="vertical-align:top;">
                        <table>
                            <tr style="height:20px;">
                                <td class="txtboldblue">&nbsp;&nbsp;&nbsp;<cf_get_lang no='986.Forum Adı'></td>
                            </tr>
                            <tr>
                                <td>
                                    <cfinclude template="../query/get_forums.cfm">
                                    &nbsp;&nbsp;
                                    <select name="forum_subject" id="forum_subject" style="width:200px;">
                                        <cfoutput query="forums">
                                        <option value="#forumid#" <cfif attributes.forumid eq forumid>selected</cfif>>#forumname#</option>
                                        </cfoutput>
                                    </select>
                                    &nbsp;&nbsp;
                                    <input type="checkbox" name="locked" id="locked" value="1">
                                    <cf_get_lang no='987.Yeni Cevap Kapalı'>
                                </td>
                            </tr>
                            <tr style="height:20px;">
                                <td class="txtboldblue">&nbsp;&nbsp;&nbsp;<cf_get_lang_main no='68.Başlık'></td>
                            </tr>
                            <tr>
                                <td> 
                                    &nbsp;&nbsp;&nbsp;
                                    <input type="Text" name="title" id="title" style="width:96%">
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align:top;">
                                    <cfmodule template="../../../fckeditor/fckeditor.cfm"
                                        toolbarset="Basic"
                                        basepath="/fckeditor/"
                                        instancename="topic"
                                        valign="top"
                                        value=""
                                        width="550"
                                        height="300">
                                </td>
                            </tr>
                            <tr style="height:20px;">
                                <td class="txtboldblue">&nbsp;&nbsp;&nbsp;<cf_get_lang_main no='103.Dosya Ekle'></td>
                            </tr>
                            <tr>
                                <td> 
                                    &nbsp;&nbsp;&nbsp;
                                    <input type="file" name="attach_topic_file" id="attach_topic_file" style="width:96%">
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right;" colspan="2" height="35">
                                    <cf_workcube_buttons is_upd='0' add_function='OnFormSubmit()'>&nbsp;&nbsp; 
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</cfform>

