<table cellspacing="1" cellpadding="2" border="0" class="color-border" style="width:100%; height:100%;">
	<tr class="color-list" style="height:35px; vertical-align:middle;">
  		<td>
			<table align="center" style="width:98%;">
	  			<tr>
					<td class="headbold" style="vertical-align:bottom;"><cf_get_lang no='732.Proje  Ekibine Mail Gönder'></td>
	  			</tr>
			</table>
	  	</td>
	</tr>
    <tr class="color-row">
        <td style="vertical-align:top;">
            <table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%;">
            	<tr>
            		<td colspan="2"> <br/>
            			<cfform name="form_add_mail" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_mail&id=#url.id#">
            				<table>
            					<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#url.id#</cfoutput>">
                                <tr>
                                	<td><cf_get_lang_main no='68.Başlık'> *</td>
                                </tr>
                                <tr>
                                	<td>
                                    <cfsavecontent variable="message"><cf_get_lang no='731.Mail Başlığını Girmediniz.'></cfsavecontent>
                                    <cfinput type="text" name="mail_subject" id="mail_subject" value="" required="Yes" message="#message#." maxlength="75" style="width:320px;"></td>
                                </tr>
                                <tr>
	                                <td><cf_get_lang_main no='359.Ayrıntı'></td>
                                </tr>
                                <tr>
    	                            <td><textarea name="mail_body" id="mail_body" style="width:320px;height:140px;"></textarea></td>
                                </tr>
                                <tr align="center" style="height:35px;">
        	                        <td colspan="2" align="right" style="text-align:right;"> <cf_workcube_buttons is_upd='0'> </td>
                                </tr>                    
                    		</table>
                    	</cfform>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>



