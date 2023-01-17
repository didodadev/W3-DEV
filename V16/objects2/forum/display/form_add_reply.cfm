<cfinclude template="../../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfinclude template="../query/get_email_alert.cfm">
<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:98%; height:35px;">
  	<tr>
    	<td class="headbold"><cf_get_lang no='982.Konuya Cevap Ver'></td>
  	</tr>
</table>

<cfform enctype="multipart/form-data" action="#request.self#?fuseaction=objects2.emptypopup_add_reply" method="post" name="add_reply">
<table border="0" cellspacing="1" cellpadding="2" class="color-border" align="center" style="width:98%;">
	<tr>
		<input type="hidden" name="topicid" id="topicid" value="<cfoutput>#attributes.topicid#</cfoutput>">
		<cfif isdefined("attributes.replyid")>
			<input type="hidden" name="replyid" id="replyid" value="<cfoutput>#attributes.replyid#</cfoutput>">
		</cfif>
		<td class="color-row" style="vertical-align:top; width:100px;">
		  	<table>
				<tr>
			  		<td class="txtboldblue"><cf_get_lang no='983.İmge Seçiniz'></td>
				</tr>
				<cfoutput>
			  		<cfloop from="1" to="16" index="i">
						<tr>
				  			<td>
                            	<input type="Radio" name="imageid" id="imageid" value="#i#" <cfif i eq 1>checked</cfif>>
								<img src="/forum/images/data/icon#i#.gif" border="0">
                            </td>
						</tr>
			  		</cfloop>
				</cfoutput>
		  	</table>
		</td>
		<td class="color-row" style="vertical-align:top;"> 
		  	<table>
				<tr>
			  		<td>&nbsp;
						<cfif isdefined("session.ww.userid")>
                            <input type="Checkbox" name="email_emp" id="email_emp" value="<cfoutput>#session.ww.userid#</cfoutput>" <cfif listfindnocase(valuelist(email_alert.email_emps),session.ww.userid)>checked</cfif>>
                        <cfelseif isdefined("session.pp.userid")>
                            <input type="Checkbox" name="email_emp" id="email_emp" value="<cfoutput>#session.pp.userid#</cfoutput>" <cfif listfindnocase(valuelist(email_alert.email_emps),session.pp.userid)>checked</cfif>>
                        </cfif>
						<cf_get_lang no='984.Cevapları Mail Gönder'>
			  		</td>
				</tr>
				<tr>
			  		<td>
              			<cfmodule
                            template="../../../fckeditor/fckeditor.cfm"
                            toolbarSet="WRKContent"
                            basePath="/fckeditor/"
                            instanceName="reply"
                            valign="top"
                            value=""
                            width="600"
                            height="300">
					</td>
				</tr>
				<tr style="height:20px;">
			  		<td class="txtboldblue">&nbsp;&nbsp;&nbsp;<cf_get_lang_main no='103.Dosya Ekle'></td>
				</tr>
				<tr>
			  		<td> 
                    	&nbsp;&nbsp;&nbsp;
						<input type="file" name="attach_reply_file" id="attach_reply_file" style="width:96%">
			  		</td>
				</tr>
                <tr style="height:35px;">
                    <td colspan="2"  style="text-align:right;">
                        <!---<cf_workcube_buttons is_upd='0' add_function='OnFormSubmit()'>--->
                        <cf_workcube_buttons is_upd='0'>
                        &nbsp;&nbsp;&nbsp;
                    </td>
                </tr>
            </table>
        </td>  
    </tr>
</table>
</cfform>
<br/>

