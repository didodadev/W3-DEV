<cf_ajax_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='46015.Ders'></th>
            <th style="width:90px;"><cf_get_lang_main no='243.Başlama'></th>
            <th style="width:90px;"><cf_get_lang_main no='288.Bitiş T'></th>
            <th style="width:15px;">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
        <cfinclude template="../query/get_class_ang_groups.cfm">
        <cfset tr_attainer_points=ArrayNew(2)>
        <cfset tr_trainer_points=ArrayNew(2)>				
        <cfset max_class_num=get_trainings.recordcount>
        <cfif get_trainings.recordcount>
            <cfoutput query="get_trainings">
                <tr>
                    <td><a href="#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#class_id#" class="tableyazi" target="_blank">#class_name#</a></td>
                    <td style="font-weight:bold">
                        <cfif Len(get_trainings.start_date)>
                            <cfset attributes.startdate = date_add('h', session.ep.time_zone,get_trainings.start_date)>
                            #dateformat(attributes.startdate,dateformat_style)#&nbsp;#timeformat(attributes.startdate,timeformat_style)#
                        </cfif>
                    </td>
                    <td style="font-weight:bold">
                        <cfif Len(get_trainings.finish_date)>
                            <cfset attributes.finishdate = date_add('h', session.ep.time_zone,get_trainings.finish_date)>
                            #dateformat(attributes.finishdate,dateformat_style)#&nbsp;#timeformat(attributes.finishdate,timeformat_style)#
                        </cfif>
                    </td>
                    <cfset attributes.class_id=class_id>
                    <td>
                        <cfquery name="GET_TRAININGS_INFO" datasource="#DSN#">
                            SELECT
                                AVG(FINALTEST_POINT) AS AVG_TOTAL,
                                SUM(FINALTEST_POINT) AS SUM_TOTAL,
                                COUNT(FINALTEST_POINT) AS COUNT_TOTAL
                            FROM
                                TRAINING_CLASS_RESULTS
                            WHERE
                                CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
                        </cfquery>						
                        <cfset tr_attainer_points[currentrow][4]=class_name>
                    <cfif len(get_trainings_info.avg_total)>
                        <cfset tr_attainer_points[currentrow][1]=get_trainings_info.avg_total>
                    <cfelse>
                        <cfset tr_attainer_points[currentrow][1]=0>
                    </cfif>
                    <cfinclude template="../query/get_trainer_eval_info.cfm">	
                    <cfset tr_trainer_points[currentrow][4]=class_name>
                    <cfif len(get_trainer.avg_total)>
                        <cfset tr_trainer_points[currentrow][1]=get_trainer.avg_total>
                    <cfelse>
                        <cfset tr_trainer_points[currentrow][1]=0>
                    </cfif>									
                    <a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=training_management.popup_del_class_from_group&class_group_id=#class_group_id#&class_id=#attributes.class_id#&train_group_id=#train_group_id#','medium');"><i class="fa fa-minus"></i></a>
                    </td>
                </tr>
            </cfoutput>
            <cfelse>
            <td colspan="4" style="font-size: 12px;"><cf_get_lang_main no="72.Kayıt Yok">!</td>
        </cfif>
    </tbody>
</cf_ajax_list>
