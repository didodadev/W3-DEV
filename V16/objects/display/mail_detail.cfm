<cfsavecontent variable="message"><cf_get_lang dictionary_id='57475.Mail Gönder'></cfsavecontent>
<cf_popup_box title="#message#">
    <form name="send_mail">
    <div class="row">
        <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
		<div class="form-group" id="item-to_id">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32773.TO'></label>
            <div class="col col-8 col-xs-12">
			<div class="input-group">
            		<input type="hidden" name="to_id" id="to_id"> 
	            	<input style="width:275px;" type="text" name="to" id="to" value="<cfif isDefined("ccs")><cfoutput>#ccs#</cfoutput></cfif>">				   				   
					<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_mail&mail_id=send_mail.to_id&names=send_mail.to','list')"></span>
            </div>
		</div>
	</div>		
        <div class="form-group" id="item-cc_id">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32774.CC'></label>
            <div class="col col-8 col-xs-12">
			<div class="input-group">
            		<input type="hidden" name="cc_id" id="cc_id"> 
            		<input style="width:275px;" type="text" name="cc" id="cc">				
					<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_mail&mail_id=send_mail.cc_id&names=send_mail.cc','list')"></span>
            </div>
		</div>
	</div>		
       <div class="form-group" id="item-cc_id">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'></label>
            <div class="col col-8 col-xs-12">
            	<input  style="width:275" type="text" name="subject" id="subject">
            </div>
		</div>
	</div>
</div>			
		<cf_popup_box_footer>
        <table align="right">
        	<tr>
            	<td>
                    <input type="button" style="width:65px;" onClick="javascript:sen_mail();return true;"  value="<cf_get_lang dictionary_id='58743.Gönder'>">
                    <cfsavecontent variable="send_mail"><cf_get_lang dictionary_id ='34195.Mail Göndermekten Vazgeçiyorsunuz Emin misiniz'></cfsavecontent>
                    <input type="button" style="width:65px;" onClick="javascript:if (confirm('#send_mail#')) window.close(); else return;" value="<cf_get_lang dictionary_id='57462.Vazgeç'>">
                </td>
            </tr>
        </table>
        </cf_popup_box_footer>	
    </form>
</cf_popup_box>

<script type="text/javascript">

document.send_mail.subject.value = window.opener.operations.subject.value;
window.moveTo(300,50);
function sen_mail(){

	if (document.send_mail.to.value != '')
		   window.opener.operations.to_id.value = document.send_mail.to.value;
	if (document.send_mail.cc.value != '')
		   window.opener.operations.cc_id.value = document.send_mail.cc.value;
	if (document.send_mail.subject.value != '')
		   window.opener.operations.subject.value = document.send_mail.subject.value;
	window.opener.operations.action = '<cfoutput>#request.self#?fuseaction=objects.popup_operate_action&operation=#attributes.operation#&action=#attributes.action#&id=#attributes.id#&module=#attributes.module#<cfif isDefined("attributes.full_operations")>&full_operations</cfif><cfif isDefined("attributes.trail")>&trail=1</cfif></cfoutput>';
	window.opener.operations.submit();
	window.close();
}
</script>
