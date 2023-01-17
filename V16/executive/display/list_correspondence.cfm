<cfset attributes.death = 0>
<cfparam name="attributes.keyword" default="">
<cfparam name="mails" default="">
<cfif isdefined("attributes.cpid")>
	<cfinclude template="../query/get_mails.cfm">
<cfelse>
	<cfset get_mails.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_mails.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_big_list_search title="#getLang('executive',24)#">
<!---- search --->
</cf_big_list_search>
<cf_big_list>
	<cfoutput>
        <thead>
            <tr>
                <th>&nbsp;</td>
                <th><a href="##" onClick="window.location.href='#request.self#?fuseaction=executive.list_correspondence&order_subject='"><cf_get_lang_main no='68.Konu'></a></th>
                <th><a href="##" onClick="window.location.href='#request.self#?fuseaction=executive.list_correspondence&order_to='"><cf_get_lang no='26.To'></a></th>
                <th><a href="##" onClick="window.location.href='#request.self#?fuseaction=executive.list_correspondence&order_from='"><cf_get_lang no='27.From'></a></th>
                <th><a href="##"  onClick="window.location.href='#request.self#?fuseaction=executive.list_correspondence&order_date='"><cf_get_lang_main no='330.Tarih'></a></th> 
            </tr>
        </thead>
	</cfoutput>
    <tbody>
       <cfif get_mails.recordcount>
		  <cfset index = 0>
          <cfoutput query="get_mails" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr>
              <td>&nbsp; <cfif type eq 0><cf_get_lang_main no='1563.Giden'><cfelse><cf_get_lang_main no='1562.Gelen'></cfif> </td>
              <td><a href="javascript://" onClick="window.location.href='#request.self#?fuseaction=correspondence.<cfif attributes.fuseaction contains 'send_mail'>send_mail&show=dsp_mail<cfelse>dsp_mail</cfif>&mail_id=#mail_id#&type=1'"><cfif subject neq ''>#subject#<cfelse>Undetermined Subject</cfif></a></td>
              <cfset attributes.mail_id = MAIL_ID>
                      <cfscript>
                        mails = '';
                        if(len(ListSort(ValueList(MAIL_TO,","),'textnocase','asc',',')))
                            mails = ListSort(ValueList(MAIL_TO,","),'textnocase','asc',',');
                        if(len(ListSort(ValueList(MAIL_CC,","),'textnocase','asc',',')) and len(mails))
                            mails="#mails#,#ListSort(ValueList(MAIL_CC,","),'textnocase','asc',',')#";
                        else if(len(ListSort(ValueList(MAIL_CC,","),'textnocase','asc',',')))
                            mails = ListSort(ValueList(MAIL_CC,","),'textnocase','asc',',');
                            //	if(len(ListSort(ValueList(GET_MAILS_LIST.BCC_MAIL,","),'textnocase','asc',',')) and len(mails))
                            //					mails="#mails#,#ListSort(ValueList(GET_MAILS_LIST.BCC_MAIL,","),'textnocase','asc',',')#";
                            //				else if(len(ListSort(ValueList(GET_MAILS_LIST.BCC_MAIL,","),'textnocase','asc',',')))
                            //					mails = ListSort(ValueList(GET_MAILS_LIST.BCC_MAIL,","),'textnocase','asc',',');
                        mails = ReplaceList(mails, chr(10), '');
                        mails = ReplaceList(mails, chr(13), '');
                      </cfscript>
              <td>
                <cfif mails neq ''>
                  <a href="javascript://" title="#mails#"  onClick="windowopen('#request.self#?fuseaction=objects.popup_list_mail&mails=#mails#','small')">
                  <cfif Len(mails) gt 30>#left(mails,30)#...<cfelse>#mails#</cfif></a>
                </cfif>
              </td>
              <td>#mail_from#</td>
              <td>#dateformat(record_date,'dd/mm/yyyy')#</td>
            </tr>
            <cfset index = index + 1>
        </cfoutput>
      <cfelse>
        <tr>
            <td colspan="5"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
        </tr>
      </cfif>
    </tbody>
    <cfparam name="attributes.adres" default="executive.list_sent_mails&type=0">
	<cfif attributes.totalrecords gt attributes.maxrows> 
        <tfoot>
            <tr>
                <td>
                <cf_pages 
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="executive.list_sent_mails&type=0&keyword=#attributes.keyword#"></td>
                <!-- sil --><td ><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
            </tr>
        </tfoot>
    </cfif>
</cf_big_list>    
    

