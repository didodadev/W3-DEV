<cfparam name="attributes.is_popup" default="">
<cfparam name="attributes.modal_id" default="">
<cfinclude template="../../../css/assets/icons/icons.cfm">
<script type="text/javascript">
    function fnc(msg){
        icon = msg.trim();
        if(icon.substring(0,1) == '.'){
            icon = icon.substring(1,icon.length);
            if(icon.includes("fa")){
                icon = "fa " + icon;
            }
        }
        <cfif isdefined("attributes.field_name")>
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput> != undefined){
                <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = icon;
            }
			else{
                <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#attributes.field_name#</cfoutput>').value = icon;
            }
            <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		</cfif>
    }
</script>