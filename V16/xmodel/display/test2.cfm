<div class="row" type="row">
    <div class="col col-4 col-xs-12" type="column" index="1" sort="true" data-formulacontainer="minor">
         <cfsavecontent variable="boxtitle"><cf_get_lang no="1"></cfsavecontent>
         <cf_box id="minor_box" closable="0" title="#boxtitle#">
              <table class="table" data-formulasummary="false">
                   <thead>
                        <tr>
                             <td><cf_get_lang no="1"></td>

                             <td><cf_get_lang no="1"></td>

                             <td><cf_get_lang no="1"></td>
                             <td><button onclick="minor_addrow(this)">+</button></td>
                        </tr>
                   </thead>
                   <tbody>
                        <cfif isDefined("minor_query")>
                        <cfset minor_index = 1>
                        <cfoutput query="minor_query">
                        <tr data-rowindex="#minor#">
                             <td>
                                  <cfif isDefined("editableGrid") && editableGrid("minorid")>
                                  <cfoutput><input type="text" name="minorid1" id="minorid1" value="#iif(isDefined("minor_query"), "minor_query.minorid", DE(''))#"   data-rule-digits="true"  data-keyfield="minorid" data-keyvalue="#iif(isDefined("minorid"), "minorid", DE(""))#" data-name="minorid" data-grideditor="true"></cfoutput>
                                  
                                  <cfelse>
                                  #minorid#
                                  </cfif>
                             </td>


                             <td>
                                  <cfif isDefined("editableGrid") && editableGrid("minorname")>
                                  <cfoutput><input type="text" name="minorname2" id="minorname2" value="#iif(isDefined("minor_query"), "minor_query.minorname", DE(''))#"   data-rule-digits="true" minlength="5" maxlength="100" required  data-keyfield="minorid" data-keyvalue="#iif(isDefined("minorid"), "minorid", DE(""))#" data-name="minorname" data-grideditor="true"></cfoutput>
                                  
                                  <cfelse>
                                  #minorname#
                                  </cfif>
                             </td>


                             <td>
                                  <cfif isDefined("editableGrid") && editableGrid("minordetail")>
                                  <cfoutput><input type="text" name="minordetail3" id="minordetail3" value="#iif(isDefined("minor_query"), "minor_query.minordetail", DE(''))#"   data-rule-digits="true" data-clientformula="[minorid]*[minorname]" data-keyfield="minorid" data-keyvalue="#iif(isDefined("minorid"), "minorid", DE(""))#" data-name="minordetail" data-grideditor="true"></cfoutput>
                                  
                                  <cfelse>
                                  #minordetail#
                                  </cfif>
                             </td>

                             <td><input type="checkbox" data-rowselector="true"></td>
                        </tr>
                        </cfoutput>
                        </cfif>
                        <tr><td colspan="4"><button type="button" onclick="gridUpdater($(this).closest('table'), 'minor', 'table')"><cf_get_lang_main no="1"></button></td></tr>
                   </tbody>
              </table>
              <table class="table" data-formulasummary="true">
                   <tr>
                   <td><cf_get_lang no="1"></td>
                        <td><input type="text" name="mysum" id="mysum" data-clientformula="sum([minorname])"></td>
                   </tr>
                   <tr data-refname="mysum2_minorid" data-rowformula="sum([minordetail])" data-rowformulagroupby="minorid" data-elementlabel="<cf_get_lang no="1">"></tr>
              </table>
                   <script type="text/javascript">
                        function minor_addrow(ref) {
                        var appendData = `<tr data-rowindex="{index}"><td><cfoutput><input type="text" name="minorid{index}" id="minorid{index}" value="#iif(isDefined("minor_query"), "minor_query.minorid", DE(''))#"   data-rule-digits="true"  data-keyfield="minorid" data-keyvalue="#iif(isDefined("minorid"), "minorid", DE(""))#" data-name="minorid" data-grideditor="true"></cfoutput>
</td><td><cfoutput><input type="text" name="minorname{index}" id="minorname{index}" value="#iif(isDefined("minor_query"), "minor_query.minorname", DE(''))#"   data-rule-digits="true" minlength="5" maxlength="100" required  data-keyfield="minorid" data-keyvalue="#iif(isDefined("minorid"), "minorid", DE(""))#" data-name="minorname" data-grideditor="true"></cfoutput>
</td><td><cfoutput><input type="text" name="minordetail{index}" id="minordetail{index}" value="#iif(isDefined("minor_query"), "minor_query.minordetail", DE(''))#"   data-rule-digits="true" data-clientformula="[minorid]*[minorname]" data-keyfield="minorid" data-keyvalue="#iif(isDefined("minorid"), "minorid", DE(""))#" data-name="minordetail" data-grideditor="true"></cfoutput>
</td></tr>`;
                        var nanodata = { index: $(ref).closest("table").find("tbody tr").length };
                        $(ref).closest("table").find("tbody tr").last().before(nano(appendData, nanodata));
                        formulaObserver.get("minor").rebind();
                        }
                   </script>
         </cf_box>
    </div>
</div>

<script type="text/javascript" src="/JS/assets/lib/nano/nano.js"></script>
<script type="text/javascript" src="/JS/assets/lib/fparse/fparser.js"></script>
<script type="text/javascript" src="/JS/assets/custom/formulaobserver.js"></script>