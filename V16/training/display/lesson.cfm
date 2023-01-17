<cfinclude template="../query/get_training_classes.cfm">
<cfinclude template="../query/get_training_join_request.cfm">
<!---Dersler--->
<table class="ajax_list">
    <cfif get_training_classes.RecordCount>	
        <cfset training_join_list = ValueList(get_training_join_request.class_id)>
            <thead>
                <tr>
                    <th><cf_get_lang_main no='7.Eğitim'></th>
                    <th width="75"><cf_get_lang no='19.Başlangıç Tarihi'></th>
                    <th width="10"></th>
                </tr>
           </thead>
           <cfoutput query="get_training_classes">
               <tbody>
                    <tr>
                        <td><img src="/images/tree_1.gif"> #class_name#</td>
                        <td width="95">#DateFormat(date_add("h",session.ep.time_zone,start_date),dateformat_style)# #timeformat(date_add("h",session.ep.time_zone,start_date),timeformat_style)#</td>
                        <td width="10">
                            <cfif DateDiff("d",CreateODBCDate(Now()),finish_date) gte 1>
                                <cfif ListLen(training_join_list) and ListFind(training_join_list,class_id)>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=training.emptypopup_del_training_request&training_id=#attributes.training_id#&class_id=#class_id#','small')"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang no='46.Derse Katılım İsteğini Sil'>"></a>
                                <cfelse>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=training.emptypopup_add_training_request&training_id=#attributes.training_id#&class_id=#CLASS_ID#','small')"><img src="/images/plus_list.gif" border="0" title="<cf_get_lang no='48.Derse Katılım İsteği Kaydet'>"></a>
                                </cfif>
                            </cfif>
                        </td>
                    </tr>
               </tbody>
           </cfoutput>
    <cfelse>
        <tbody>
            <tr>
                <td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td> 
            </tr>
        </tbody>
    </cfif>
</table>
