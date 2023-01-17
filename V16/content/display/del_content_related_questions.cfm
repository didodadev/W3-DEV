<cfset cfc = createObject('component','V16.content.cfc.get_content')>
<cfsetting showdebugoutput="no">
<cf_box title="Soru Sil" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfset del_related_questions = cfc.del_related_questions(cntid: attributes.cntid, question_id: attributes.question_id)>
</cf_box>
<script>
    <cfif isDefined("attributes.draggable")>
        closeBoxDraggable('del_related_question_box');
        $("#related_questions .catalyst-refresh").click();
    <cfelse>
        wrk_opener_reload();
        self.close();
    </cfif>
</script>