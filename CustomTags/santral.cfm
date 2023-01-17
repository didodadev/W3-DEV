
<cfset fuseact = '#caller.attributes.fuseaction#'>
<cfset getComponent = createObject('component', 'WEX.cti.cfc.verimor')>
<cfset getCallInformations = getComponent.getCallInformations()>
<cfparam name="attributes.extension" default="#getCallInformations.extension#">
<cfparam name="attributes.extension2" default="#getCallInformations.corbus_tel#"> <!--- Çalışanın dahili numarası --->
<cfparam name="attributes.api_key" default="#getCallInformations.api_key#"> 
<cfparam name="attributes.mobil" default="">
<cfparam name="attributes.tel" default="">
<cfparam name="attributes.tel2" default="">
<cfparam name="attributes.table" default="0">
<cfparam name="attributes.list" default="0">
<cfparam name="attributes.is_iframe" default="0">
<cfoutput>
    <cfif thisTag.executionMode eq "start">
        <cfif attributes.list eq 1>
            <cfif len(attributes.mobil)>
                <li>
                    <a href="javascript://" onclick="<cfif attributes.is_iframe eq 1>beginCall('#attributes.mobil#')<cfelse>window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.phone&keyword=#attributes.mobil#&w_is_submit=1','Phone')</cfif>;" title="#attributes.mobil#" alt="#attributes.mobil#"><i class="fa fa-mobile-phone" style="color:##44b6ae"></i></a>
                </li>
            </cfif>
            <cfif len(attributes.tel)>
                <li>
                    <a href="javascript://" onclick="<cfif attributes.is_iframe eq 1>beginCall('#attributes.tel#')<cfelse>window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.phone&keyword=#attributes.tel#&w_is_submit=1','Phone')</cfif>;" title="#attributes.tel#" alt="#attributes.tel#"><i class="fa fa-phone" style="color:##44b6ae"></i></a>
                </li>
            </cfif>
        <cfelseif attributes.table eq 1>
            <td>
                <cfif len(attributes.mobil)>
                    <span onclick="<cfif attributes.is_iframe eq 1>beginCall('#attributes.mobil#')<cfelse>window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.phone&keyword=#attributes.mobil#&w_is_submit=1','Phone')</cfif>;" class="btnPointer" title="#attributes.mobil#" alt="#attributes.mobil#">#attributes.mobil#<i class="fa fa-mobile-phone padding-left-5" style="color:##44b6ae!important"></i></span>
                </cfif>
            </td>
            <td>
                <cfif len(attributes.tel)>
                    <span onclick="<cfif attributes.is_iframe eq 1>beginCall('#attributes.tel#')<cfelse>window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.phone&keyword=#attributes.tel#&w_is_submit=1','Phone')</cfif>;" class="btnPointer" title="#attributes.tel#" alt="#attributes.tel#">#attributes.tel#<i class="fa fa-phone padding-left-5" style="color:##44b6ae!important"></i></span>
                </cfif>
            </td>
            <td>
                <cfif len(attributes.tel2)>
                    <span onclick="<cfif attributes.is_iframe eq 1>beginCall('#attributes.tel2#')<cfelse>window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.phone&keyword=#attributes.tel2#&w_is_submit=1','Phone')</cfif>;" class="btnPointer" title="#attributes.tel2#" alt="#attributes.tel2#">#attributes.tel2#<i class="fa fa-phone padding-left-5" style="color:##44b6ae!important"></i></span>
                </cfif>
            </td>
        <cfelse>
            <cfif len(attributes.mobil)>
                <span onclick="<cfif attributes.is_iframe eq 1>beginCall('#attributes.mobil#')<cfelse>window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.phone&keyword=#attributes.mobil#&w_is_submit=1','Phone')</cfif>;" class="btnPointer" title="#attributes.mobil#" alt="#attributes.mobil#"><i class="fa fa-mobile-phone padding-right-5" style="color:##44b6ae"></i>#attributes.mobil#</span>
            </cfif>
            <cfif len(attributes.tel)>
                <span onclick="<cfif attributes.is_iframe eq 1>beginCall('#attributes.tel#')<cfelse>window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.phone&keyword=#attributes.tel#&w_is_submit=1','Phone')</cfif>;" class="btnPointer" title="#attributes.tel#" alt="#attributes.tel#"><i class="fa fa-phone padding-right-5" style="color:##44b6ae"></i>#attributes.tel#</span>
            </cfif>
            
        </cfif>
         <cfif len(attributes.extension) and len(attributes.api_key) and (len(attributes.mobil) or len(attributes.tel))>
            <script>
                function beginCall(destination){
                    if(confirm("Arama yapmak istediğinize emin misiniz?"))	
                    {
                        var formObjects = {};
                        formObjects.api_key="<cfoutput>#attributes.api_key#</cfoutput>";
                        formObjects.extension="<cfoutput>#attributes.extension#</cfoutput>";
                        formObjects.destination=destination;
                        $.ajax({
                            url :'/wex.cfm/cti/beginCall',
                            method: 'post',
                            contentType: 'application/json; charset=utf-8',
                            dataType: "json",
                            data : JSON.stringify(formObjects),
                            error :  function(response){
                                <cfif attributes.is_iframe eq 1>
                                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=call.list_callcenter&form_submitted=1&webphone=1&tel=' + destination + '&MOBILTEL=' + destination,'item-contact');  
                                <cfelse>
                                    window.open('#request.self#?fuseaction=call.list_callcenter&form_submitted=1&tel='+destination+'MOBILTEL='+destination);
                                </cfif>                                
                            }

                        });
                    }
                    else return false;                    
                }
            </script>
        </cfif>
    <cfelse>

    </cfif>
</cfoutput>