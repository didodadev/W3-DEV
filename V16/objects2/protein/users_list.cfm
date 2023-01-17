<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfif isDefined("session.pp")>
    <cfset company_id = session.pp.company_id>
<cfelseif isDefined("session.ww")>
    <cfset company_id = session.ww.company_id>
</cfif>

<cfscript>

    get_partner = company_cmp.get_partner_(
        cpid : company_id
    );

    get_partner_positions = company_cmp.GET_PARTNER_POSITIONS();

</cfscript>
<cfsavecontent  variable="title"><cf_get_lang dictionary_id='52612.Update User'></cfsavecontent>
<div class="table-responsive-lg">
    <table class="table">
        <thead class="main-bg-color">
            <tr>                          
                <th class="text-uppercase"><cf_get_lang dictionary_id='57570.Name  Last name'></th>
                <th class="text-uppercase"><cf_get_lang dictionary_id='58497.Position'></th>
                <th class="text-uppercase"><cf_get_lang dictionary_id='42782.E-Mail'></th>
                <th class="text-uppercase"><cf_get_lang dictionary_id='58473.Mobile'></th>
                <th class="text-uppercase" colspan="2"><cf_get_lang dictionary_id='38628.?'></th>    
            </tr>
        </thead>
        <tbody>
            <cfif get_partner.recordcount>
                <cfoutput query="get_partner">
                    <tr>
                        <cfif len(MISSION)>
                            <cfquery name="user_position" dbtype="query">
                                SELECT * FROM get_partner_positions WHERE PARTNER_POSITION_ID = #MISSION#
                            </cfquery>
                        <cfelse>
                            <cfset user_position.recordcount = 0>
                        </cfif>
                        <td scope="row">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</td>
                        <td>
                            <cfif len(MISSION)>
                                #user_position.PARTNER_POSITION#
                            </cfif>
                        </td>
                        <td>#COMPANY_PARTNER_EMAIL#</td>
                        <td>#len(MOBIL_CODE) ? '#MOBIL_CODE# ' : ''##MOBILTEL#</td>
                        <td>#dateformat(RECORD_DATE,'dd/mm/yyyy')# #timeformat(RECORD_DATE,'HH:MM')#</td>
                        <td><a href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=updateUser&isbox=1&draggable=1&title=#title#&style=maxi&partner_id=#PARTNER_ID#')" class="none-decoration"><i class="fas fa-pencil-alt"></i></a></td>
                    </tr>        
                </cfoutput>      
            <cfelse>
                <tr>
                    <td colspan="5">
                        <cf_get_lang dictionary_id="57484.Kayıt yok">!
                    </td>
                </tr>         
            </cfif>
        </tbody>
    </table>
</div>
<script>
    <cfsavecontent  variable="titleadd"><cf_get_lang dictionary_id='29470.Add User'></cfsavecontent>
    var loader_div_message_ = "";

    $('.portHeadLightMenu ul li a').css("display", "none");

    $('.portHeadLightMenu ul')
    .append(
        $('<li>')
          .addClass('btn btn-color-5 float-right far fa-plus-square')
          .attr({
                      onclick :"openBoxDraggable('widgetloader?widget_load=addNewUser&isbox=1&draggable=1&title=<cfoutput>#titleadd#</cfoutput>&style=maxi')",
                      title		:'<cf_get_lang dictionary_id='29470.Add User'>'})           
          .text(" <cf_get_lang dictionary_id='29470.Add User'>") );  
</script>