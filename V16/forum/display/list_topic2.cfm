<cfsetting showdebugoutput="no">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.topic_status" default="1">
<cfinclude template="../query/get_topics.cfm">
<cfinclude template="../query/get_forums.cfm">
<cfinclude template="../query/get_forum_name.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='5'>
<cfparam name="attributes.totalrecords" default=#topics.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_medium_list>
<thead>
    <tr>
      <th align="center"><a href="<cfoutput>#request.self#?fuseaction=forum.form_add_topic&forumid=#attributes.forumid#</cfoutput>"><img title="<cf_get_lang no='4.Konu Ekle'>" src="images/folder_add_list.gif" border="0"></a></th>
      <th><cf_get_lang_main no='68.Konu'></th>
      <th style="width:110px;"><cf_get_lang no='35.Konuyu Açan'></th>
      <th style="width:5px;"><cf_get_lang_main no='1242.Cevap'></th>
      <th style="width:50px;"><cf_get_lang no='38.Okuyan'></th>
      <th style="width:110px;"><cf_get_lang no='39.Konu Açılışı'></th>
      <th style="width:110px;"><cf_get_lang no='40.Son Cevap'></th>      
    </tr>
</thead>
<tbody>
    <cfif topics.recordcount>
	<cfoutput query="topics" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
    	<tr>
            <td align="center" width="30"><img src="V16/forum/images/data/icon#ImageID#.gif" title="" border="0"></td>
            <td width="250">
				<cfif locked eq 1>
                    <img src="V16/forum/images/data/icon_folder_locked.gif" title="<cf_get_lang no='57.Kapalı Konu'>" align="absmiddle">
                </cfif>
                <a href="#request.self#?fuseaction=forum.view_reply&topicid=#topics.topicid#" class="tableyazi">#mid(title,1,35)#
                <cfif len(title) gt 35> ... </cfif>
                </a>
            </td>
			<cfset attributes.userkey = userkey>
            <cfinclude template="../query/get_username.cfm">
            <td>
				<cfif listfirst(attributes.userkey,"-") is "e">
                    <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(attributes.userkey,"-")#','medium');" class="tableyazi">#username.name# #username.surname#</a>
				<cfelseif listfirst(attributes.userkey,"-") is "p">
                    <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(attributes.userkey,"-")#','medium');" class="tableyazi">#username.name# #username.surname#</a>
				<cfelseif listfirst(attributes.userkey,"-") is "c">
                    <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#listlast(attributes.userkey,"-")#','medium');" class="tableyazi">#username.name# #username.surname#</a>
                </cfif>
            </td>
            <td align="center">#reply_count#</td>
            <td align="center">#view_count#</td>
            <td align="left" style="text-align:left">
            	#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)#&nbsp;&nbsp;&nbsp;#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</td>
				<cfset attributes.userkey = last_reply_userkey>
                <cfinclude template="../query/get_username.cfm">
            <td width="90">
				<cfif len(last_reply_date)>
                    #dateformat(date_add('h',session.ep.time_zone,last_reply_date),dateformat_style)#&nbsp; #timeformat(date_add('h',session.ep.time_zone,last_reply_date),timeformat_style)#
					<cfif listfirst(attributes.userkey,"-") is "e">
                        <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(attributes.userkey,"-")#','medium');" class="tableyazi">#username.name# #username.surname#</a>
                    <cfelseif listfirst(attributes.userkey,"-") is "p">
                        <a href="javascript://"  onclick="windowopen('#request.self#?fuseactionobjects.popup_par_det&par_id=#listlast(attributes.userkey,"-")#','medium');" class="tableyazi">#username.name# #username.surname#</a>
                    <cfelseif listfirst(attributes.userkey,"-") is "c">
                        <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&cons_id=#listlast(attributes.userkey,"-")#','medium');" class="tableyazi">#username.name# #username.surname#</a>
                    </cfif>
                <cfelse>
                    <cf_get_lang no='41.Cevap Bulunamadı'>
                </cfif>
            </td>          
    	</tr>           
    </cfoutput>
    </cfif>
</tbody>
</cf_medium_list>
