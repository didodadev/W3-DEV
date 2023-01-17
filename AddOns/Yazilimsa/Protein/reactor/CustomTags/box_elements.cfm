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
<cfif thisTag.executionMode eq "start">
        <div class="ui-form-list <cfif attributes.vertical eq 1> ui-form-block</cfif> row" type="row" id="<cfoutput>#attributes.id#</cfoutput>"> 
<cfelse>
        </div>
            
</cfif>
