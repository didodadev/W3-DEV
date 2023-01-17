<style>
    .class_detail {padding: 10px;}
</style>
<cfset cfc = createObject("component","V16.training_management.cfc.training_groups")>
<cfset attenders = cfc.get_requested_attender_check(train_group_id: attributes.train_group_id, user_id: attributes.user_id)>
<cfset training_group = cfc.get_training_group(train_group_id: attributes.train_group_id)>
<cf_box title="#getLang('','Sınıf',32326)#: #training_group.GROUP_HEAD#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <div style="display:none" class="ui-cfmodal ui-cfmodal__alert">
        <cf_box>
            <div class="ui-cfmodal-close">×</div>
            <ul class="required_list"></ul>
        </cf_box>
    </div>
    <cfif (attenders.JOIN_REQUEST eq 1 and attenders.STATUS eq 0) or (attenders.JOIN_REQUEST eq 0 and attenders.STATUS eq 1)>
        <cf_get_lang dictionary_id='65163.Bu sınıfa daha önce başvuru yapmıştınız.'>
    <cfelse>
        <div class="class_detail">
            <cfoutput>
                #training_group.GROUP_DETAIL#
            </cfoutput>
        </div>
        <cfform name="join_class_form" method="post">
            <cfinput name="user_id" id="user_id" value="#attributes.user_id#" type="hidden">
            <cfinput name="train_group_id" id="train_group_id" value="#attributes.train_group_id#" type="hidden">
            <cf_box_footer>
                <div id="loading"></div>
                <cf_workcube_buttons add_function="addJoin()">
            </cf_box_footer>
        </cfform>
    </cfif>
</cf_box>
<script>
    $('.ui-cfmodal-close').click(function(){
        $('.ui-cfmodal__alert').fadeOut();
        $('.ui-cfmodal__alert .required_list').empty();
    });
    function addJoin(){/* <cf_get_lang dictionary_id='59958.En kısa sürede e-mailinize yanıt vermeye çalışacağız'> */
        $.ajax({
            url: "/V16/training_management/cfc/training_groups.cfc?method=add_join_request_to_training_group&user_id=<cfoutput>#attributes.user_id#</cfoutput>&train_group_id=<cfoutput>#attributes.train_group_id#</cfoutput>",
            beforeSend: function(  ) {
                $("#loading").html('<cfoutput>#getLang('','İşleniyor',57705)#</cfoutput>...');
            }
        })
        .done(function() {
            $('.ui-cfmodal__alert .required_list').append('<li class="required"><i style="background-color:#0f0;" class="fa fa-terminal"></i><cfoutput>#getLang('','Başvuru',31036)# #getLang('','Tamamlandı',58786)#</cfoutput></li>');
            closeBoxDraggable('joinClassBox');
            $('.ui-cfmodal__alert').fadeIn();
        });
        return false;
    }
</script>