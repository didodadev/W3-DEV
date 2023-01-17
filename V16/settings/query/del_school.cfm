<cf_box scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfquery name="DEL_SCHOOL" datasource="#DSN#">
        DELETE FROM SETUP_SCHOOL WHERE SCHOOL_ID = #attributes.school_id#
    </cfquery>
</cf_box>
<script type="text/javascript">
    <cfif isDefined("attributes.draggable") and attributes.draggable eq 1>
        closeBoxDraggable('upd_school_box');
        closeBoxDraggable('del_school_box');
        location.reload();
    <cfelse>
        wrk_opener_reload();
        self.close();
    </cfif>
</script>