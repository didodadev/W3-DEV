<!--- 
    Author : Uğur Hamurpet
    Date : 31/08/2020
    Desc : Add new or update release note row query
--->

<cfscript>
    
    release_row_obj = createObject('component','V16.objects.cfc.release_note_row');

    if( isdefined('attributes.note_row_id') and len(attributes.note_row_id) ){
        
        if(attributes.event eq 'del'){

            response = release_row_obj.delete( note_row_id : attributes.note_row_id );

        }else{

            response = release_row_obj.update(
                note_row_id : attributes.note_row_id,
                task_id : isdefined("attributes.task_id") and len(attributes.task_id) ? attributes.task_id : 0,
                hook_id : isdefined("attributes.hook_id") and len(attributes.hook_id) ? attributes.hook_id : 0,
                release_no : attributes.release_no,
                patch_no : isdefined("attributes.patch_no") and len(attributes.patch_no) ? attributes.patch_no : '',
                note_row_type : attributes.note_row_type,
                note_row_title : isdefined("attributes.note_row_title") and len(attributes.note_row_title) ? attributes.note_row_title : '',
                note_row_detail : attributes.note_row_detail,
                note_row_status : isdefined("attributes.note_row_status") and len(attributes.note_row_status) ? attributes.note_row_status : false
            );

        }

    }else{
        response = release_row_obj.insert(
            task_id : isdefined("attributes.task_id") and len(attributes.task_id) ? attributes.task_id : 0,
            hook_id : isdefined("attributes.hook_id") and len(attributes.hook_id) ? attributes.hook_id : 0,
            release_no : attributes.release_no,
            patch_no : isdefined("attributes.patch_no") and len(attributes.patch_no) ? attributes.patch_no : '',
            note_row_type : attributes.note_row_type,
            note_row_title : isdefined("attributes.note_row_title") and len(attributes.note_row_title) ? attributes.note_row_title : '',
            note_row_detail : attributes.note_row_detail,
            note_row_status : isdefined("attributes.note_row_status") and len(attributes.note_row_status) ? attributes.note_row_status : false
        );
    }

    if( response.status ) WriteOutput("<script>location.reload();</script>");

</cfscript>