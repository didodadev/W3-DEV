<cfscript>
temp_tr_id = evaluate("session.hr.t_#t_id#.tr_id[row_id]");
temp_tr_name = evaluate("session.hr.t_#t_id#.tr_name[row_id]");
ArraySet(evaluate("session.hr.t_#t_id#.tr_id"),row_id,row_id,evaluate("session.hr.t_#t_id#.tr_id[row_id+1]"));
ArraySet(evaluate("session.hr.t_#t_id#.tr_name"),row_id,row_id,evaluate("session.hr.t_#t_id#.tr_name[row_id+1]"));
ArraySet(evaluate("session.hr.t_#t_id#.tr_id"),row_id+1,row_id+1,temp_tr_id);
ArraySet(evaluate("session.hr.t_#t_id#.tr_name"),row_id+1,row_id+1,temp_tr_name);
</cfscript>

<cflocation url="#request.self#?fuseaction=hr.popup_list_position_track_relations&t_id=#t_id#" addtoken="no">
