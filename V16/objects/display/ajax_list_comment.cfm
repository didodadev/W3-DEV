<cfsetting showdebugoutput="no">
<cfparam name="attributes.totalrecords" default='0'>
<cfparam name="attributes.add_comment" default="">
<cfparam name="attributes.upd_comment" default="">
<cfparam name="attributes.col_comment_id" default="">
<cfparam name="attributes.upd_row_id" default="">
<cfparam name="attributes.record_id" default="">
<cfparam name="attributes.MAIL_ADDRESS" default="">
<cfparam name="attributes.NAME" default="">
<cfparam name="attributes.SURNAME" default="">
<cfparam name="attributes.ADD_COMMENT" default="">
<cfparam name="attributes.form_submitted" default="">
<cfquery name="GET_COMMENT" datasource="#attributes.data_source#">
    SELECT *  FROM #attributes.table_name# WHERE #attributes.col_id# = #attributes.action_id# ORDER BY RECORD_DATE DESC
</cfquery>
<cfquery name="get_employee_email" datasource="#dsn#">
    SELECT EMPLOYEE_EMAIL,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfset form_submit="&action_id=#attributes.action_id#&table_name=#attributes.table_name#&data_source=#attributes.data_source#&col_name=#attributes.col_name#&col_id=#attributes.col_id#&col_comment_id=#attributes.col_comment_id#">
<div id="show_user_message_cont" style="position:absolute;margin-left:600;margin-top:5;"></div>
<table class="color-row" cellpadding="2" cellspacing="1" border="0">
    <cfform name="_custom_tag_comment_" method="post" action="#request.self#?fuseaction=objects.add_custom_tag_comment">
        <input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
        <input type="hidden" name="col_comment_id" id="col_comment_id" value="<cfoutput>#attributes.col_comment_id#</cfoutput>">
        <input type="hidden" name="COL_ID" id="COL_ID" value="<cfoutput>#attributes.COL_ID#</cfoutput>">
        <input type="hidden" name="COL_NAME" id="COL_NAME" value="<cfoutput>#attributes.COL_NAME#</cfoutput>">
        <input type="hidden" name="DATA_SOURCE" id="DATA_SOURCE" value="<cfoutput>#attributes.DATA_SOURCE#</cfoutput>">
        <input type="hidden" name="TABLE_NAME" id="TABLE_NAME" value="<cfoutput>#attributes.TABLE_NAME#</cfoutput>">
        <tr class="color-row">
            <td><input type="hidden" name="NAME" id="NAME"  value="<cfoutput>#session.ep.name#</cfoutput>"></td>
            <td><input type="hidden" name="SURNAME" id="SURNAME" value="<cfoutput>#session.ep.surname#</cfoutput>"></td>
            <td><input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#get_employee_email.EMPLOYEE_ID#</cfoutput>"></td>
            <td><cfinput type="hidden" name="MAIL_ADDRESS" id="MAIL_ADDRESS" value="#get_employee_email.employee_email#"></td>
        </tr>	
        <tr>
            <td nowrap>
                <textarea style="width:580px;height:50px;" name="ADD_COMMENT" id="ADD_COMMENT" onChange="counter(this.form.ADD_COMMENT,this.form.ADD_COMMENTLEN,500);return ismaxlength(this);" 
                    maxlength="500" onkeydown="counter(this.form.ADD_COMMENT,this.form.ADD_COMMENTLEN,500);return ismaxlength(this);" onkeyup="counter(this.form.ADD_COMMENT,this.form.ADD_COMMENTLEN,500);return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
                <input type="text" name="ADD_COMMENTLEN"  id="ADD_COMMENTLEN" size="1"  style="width:25" value="500" readonly />
                <input type="button"  value="<cf_get_lang dictionary_id='32970.Yorum Yap'>" onClick="AjaxFormSubmit('_custom_tag_comment_','show_user_message_cont',1,'Kaydediliyor!','Kaydedildi!','<cfoutput>#request.self#?fuseaction=objects.list_comment#form_submit#</cfoutput>','show_comment');">
                <cfparam name="attributes.page" default='1'>
                <cfparam name="attributes._maxrows_" default='20'>
               <cfif GET_COMMENT.recordcount>
                    <cfset attributes.totalrecords=GET_COMMENT.recordcount>
                    <cfset attributes.startrow=((attributes.page-1)*attributes._maxrows_)+1>
			   </cfif>
			   <cfif attributes.totalrecords  gt attributes._maxrows_>
					<cfset url_str = "">
                    <cfif len(attributes.action_id)>
                        <cfset url_str = "#url_str#&action_id=#attributes.action_id#">
                    </cfif> 
                    <cfif len(attributes.col_comment_id)>
                        <cfset url_str = "#url_str#&col_comment_id=#attributes.col_comment_id#">
                    </cfif>
                    <cfif len(attributes.COL_ID)>
                        <cfset url_str = "#url_str#&COL_ID=#attributes.COL_ID#">
                    </cfif>
                    <cfif len(attributes.COL_NAME)>
                        <cfset url_str = "#url_str#&COL_NAME=#attributes.COL_NAME#">
                    </cfif>
                    <cfif len(attributes.DATA_SOURCE)>
                        <cfset url_str = "#url_str#&DATA_SOURCE=#attributes.DATA_SOURCE#">
                    </cfif>
                    <cfif len(attributes.TABLE_NAME)>
                        <cfset url_str = "#url_str#&TABLE_NAME=#attributes.TABLE_NAME#">
                    </cfif>
					<cfset _lastpage_ = (attributes.totalrecords \ attributes._maxrows_) + iif(attributes.totalrecords mod attributes._maxrows_,1,0) >
					<cfoutput>
                    <select name="select_pages_ajax" id="select_pages_ajax" onChange="AjaxPageLoad('#request.self#?fuseaction=objects.list_comment#url_str#&page='+this.value+'','show_comment',1);">
                        <cfloop from="1" to="#_lastpage_#" index="pp">
                            <option value="#pp#"<cfif attributes.page eq pp >selected</cfif>>#pp#</option>
                        </cfloop>
                    </select>.<cf_get_lang dictionary_id="32971.Sayfaya Git"> 
                    </cfoutput>
                </cfif>
            </td>
        </tr>
    </cfform>
</table>
	<cfif GET_COMMENT.recordcount>
        <cfoutput query="GET_COMMENT" startrow="#attributes.startrow#" maxrows="#attributes._maxrows_#">
            <cfform name="custom_tag_comment#currentrow#" method="post" action="#request.self#?fuseaction=objects.upd_custom_tag_comment">
            <table class="color-row" cellpadding="2" cellspacing="1" border="0">
                <tr id="_COMMENT#currentrow#" class="color-row" height="75"> 
                	<td>
                        <table cellpadding="1" cellspacing="1" border="0" class="color-row"> 
                            <tr height="20">
                                <input name="form_submitted" id="form_submitted" type="hidden" value="1">
                                <input type="hidden" name="is_delete" id="is_delete" value="0">
                                <input type="hidden" name="action_id" id="action_id" value="#attributes.action_id#">
                                <input type="hidden" name="col_comment_id" id="col_comment_id" value="#attributes.col_comment_id#">
                                <input type="hidden" name="upd_row_id" id="upd_row_id" value="#Evaluate('#attributes.col_comment_id#')#">
                                <input type="hidden" name="COL_ID" id="COL_ID" value="#attributes.COL_ID#">
                                <input type="hidden" name="COL_NAME" id="COL_NAME" value="#attributes.COL_NAME#">
                                <input type="hidden" name="DATA_SOURCE" id="DATA_SOURCE" value="#attributes.DATA_SOURCE#">
                                <input type="hidden" name="TABLE_NAME" id="TABLE_NAME" value="#attributes.TABLE_NAME#">
                                <td class="color-row"><textarea style="overflow:auto; width:580px; height:50px;"  name="upd_comment" id="upd_comment">#Evaluate('#attributes.col_name#')# </textarea></td> 
                                    <cfquery name="get_record_id" datasource="#dsn#">
                                        SELECT EMP_ID,PARTNER_ID,CONSUMER_ID FROM #attributes.table_name# WHERE  #attributes.col_comment_id# = #Evaluate('#attributes.col_comment_id#')#
                                    </cfquery>
                                    <cfif len(get_record_id.EMP_ID)>
                                        <cfset record_id=#get_record_id.EMP_ID#>
                                    <cfelseif len(get_record_id.PARTNER_ID)>
                                        <cfset record_id=#get_record_id.PARTNER_ID#>
                                    <cfelseif len(get_record_id.CONSUMER_ID)>
                                        <cfset record_id=#get_record_id.CONSUMER_ID#>
                                    </cfif>
                                   <cfif len(#record_id#)and ((#session.ep.userid# eq #record_id#  ) or ( #session.ep.admin# eq #record_id#))>
                                    <td  nowrap style="text-align:right;">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='60012.İlgili Yorumu Silmek İstediğinizden Emin misiniz'></cfsavecontent>
                                        <a style="cursor:pointer;" onClick="if(confirm('#message#')) {document.custom_tag_comment#currentrow#.is_delete.value=1;AjaxFormSubmit('custom_tag_comment#currentrow#','show_user_message_cont',1,'Siliniyor!','Silindi!');gizle(_COMMENT#currentrow#);} else return false;"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang dictionary_id='57463.Sil'>"></a>
                                        <a style="cursor:pointer;" onClick="AjaxFormSubmit('custom_tag_comment#currentrow#','show_user_message_cont',1,'Güncelliyor!','Güncellendi!');"><img align="top" src="images/update_list.gif" title="Yorum Düzenle" border="0"/></a> &nbsp;&nbsp;
                                    </td>
                                    </cfif>
                              </tr>
                              <tr>
                                <td><cf_get_lang dictionary_id="32974.Yorum Yapan">: #name# #surname#&nbsp; <cf_get_lang dictionary_id="57483.Kayıt">:#dateformat(GET_COMMENT.RECORD_DATE,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,GET_COMMENT.RECORD_DATE),timeformat_style)#)&nbsp;&nbsp;<cf_get_lang dictionary_id="32981.Mail Adresi">:<a href="mailto:#mail_address#"> #mail_address#</a> <br/>
                                   		 <!--- Güncelleyen: #name# #surname# &nbsp;&nbsp;<a href="mailto:#mail_address#">Mail Adresi: #mail_address#</a>&nbsp;&nbsp; Kayıt: #dateformat(GET_COMMENT.RECORD_DATE,dateformat_style)#</td> --->
                             </tr>
                       </table> 
                    </td>
                </tr>         
            </cfform>
       </cfoutput>
    <cfelse>
         <cf_get_lang dictionary_id="32982.İçeriğe Yorum Eklenmemiş">
    </cfif>
</table>
<script type="text/javascript">
function counter(field, countfield, maxlimit)
{ 
	if (field.value.length > maxlimit) 
	{
		field.value = field.value.substring(0, maxlimit);
		alert(""+maxlimit+"<cf_get_lang dictionary_id='58997.Karakterden Fazla Yazmayınız'> !"); 
	}
	else 
		countfield.value = maxlimit - field.value.length; 
} 
</script>
