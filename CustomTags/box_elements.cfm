<!--- Kullanımı
       
<cf_box_elements>
         Yatay
        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label>Form</label>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <input>
                </div>
        </div>
        Dikey
        <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                <label>Input</label>
                <input type="text">
        </div>
</cf_box_elements> --->
<cfif isdefined("caller.attributes.fuseaction")>
        <cfset caller.attributes.fuseaction = caller.attributes.fuseaction>
<cfelse>
        <cfset caller.attributes.fuseaction = "">
</cfif>
<cfparam name="attributes.id" default="ajax_list_#round(rand()*10000000)#">
<cfparam name="attributes.fuseaction" default="#caller.attributes.fuseaction#">
<cfparam name="attributes.vertical" default="0"><!--Dikey form istiyorsak , vertical="1" -->
<cfparam name="attributes.is_excel" default="1">
<cfparam name="attributes.addcol" default="0">
<cfparam name="attributes.mode" default="form">
<cfif thisTag.executionMode eq "start">
        <!--- DUXI kendi boxlarını bilir 
        <cfif not isDefined("caller.duxiboxes")>
                <cfset caller.duxiboxes = structNew()>
        </cfif>
        <cfset caller.duximodes[caller.last_box_id] = attributes.mode>
        <cfset caller.duxiboxes[caller.last_box_id] = structNew()>
        --->
        <div class="ui-row">
        <div class="ui-form-list <cfif attributes.vertical eq 1> ui-form-block</cfif> row" type="row" id="<cfoutput>#attributes.id#</cfoutput>">
        <cfif attributes.addcol>
                <cfif attributes.mode eq "form">
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                </cfif>
        </cfif>
<cfelse>
        <!---
	<cfif isDefined("caller.duxiboxes") and structKeyExists(caller.duxiboxes, caller.last_box_id)>
                <cfif attributes.mode eq "form">
                        <cftry>
                        <cfset elementarr = structKeyArray(caller.duxiboxes[caller.last_box_id])>
                        <!---<cfset CreateObject( "java", "java.util.Collections" ).Shuffle(elementarr)>--->
                        <cfloop array="#elementarr#" item="e" index="i">
                                <cfoutput>#caller.duxiboxes[caller.last_box_id][e]#</cfoutput>
                        </cfloop>
                        <cfcatch>

                        </cfcatch>
                        </cftry>
                <cfelseif attributes.mode eq "list">
                        
                </cfif>
        </cfif>
        --->
        <cfif attributes.addcol>
                <cfif attributes.mode eq "form">
                </div>
                </cfif>
        </cfif>
        </div>
        </div>
</cfif>
