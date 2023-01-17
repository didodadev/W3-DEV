
<cfswitch expression="#attributes.type#">
	<cfcase value="1">	
    	<cfquery name="getFamilies" datasource="#dsn#">
        	SELECT
            	W.WRK_FAMILY_ID,
                W.FAMILY_TYPE,
                W.IS_MENU,
                W.FAMILY_DICTIONARY_ID,
                ISNULL(S.ITEM_#UCase(session.ep.language)#,W.FAMILY) AS LANG
            FROM
            	WRK_FAMILY W
                LEFT JOIN SETUP_LANGUAGE_TR AS S ON S.DICTIONARY_ID = W.FAMILY_DICTIONARY_ID
            WHERE
            	W.WRK_SOLUTION_ID = #attributes.id#
            ORDER BY
            	ISNULL(W.RANK_NUMBER,100),
            	S.ITEM_#UCase(session.ep.language)#
        </cfquery>
            <ul class="list-group" id="sorterFamilie">
                <cfoutput query="getFamilies">
                    <li class="list-group-sub" id="wrkFamilie#WRK_FAMILY_ID#">
                        <div class="cl-12 cl-xs-12" style="padding:0;margin-bottom:.35em;"> 
                            <button type="button" class="btn btn-info btn-sm slt-btn" onclick="subElements(2,#wrk_family_id#)">F</button>
                            <h6 class="slt-padding"><span>#LANG#</span></h6>
                        </div>		
                        <div id="familySubElementsTr#wrk_family_id#" class="text-left" style="display:none;margin-top:0.65em;margin-bottom:0.65em;">            	
                            <div id = "familySubElementsDiv#wrk_family_id#"></div>            
                        </div>
                    </li>
                </cfoutput>
            </ul>
    </cfcase>	
	<cfcase value="2">
    	<cfquery name="getModules" datasource="#dsn#">
        	SELECT
            	W.*,
                ISNULL(S.ITEM_#UCase(session.ep.language)#,W.MODULE) AS LANG
            FROM
            	WRK_MODULE AS W
                LEFT JOIN SETUP_LANGUAGE_TR AS S ON W.MODULE_DICTIONARY_ID = S.DICTIONARY_ID
            WHERE
            	W.FAMILY_ID = #attributes.id#
            ORDER BY
            	ISNULL(W.RANK_NUMBER,100),
            	S.ITEM_#UCase(session.ep.language)#
        </cfquery>	
            <div class="cl-12 cl-xs-12 sltdiv">	
                <ul class="list-group" id="sorterModule">
                    <cfoutput query="getModules">
                        <li class="list-group-sub" id="wrkModule#MODULE_ID#">
                            <div class="cl-12 cl-xs-12" style="padding:0;margin-bottom:.35em;">
                                <button type="button" class="btn btn-success btn-sm slt-btn" onclick="subElements(3,#MODULE_ID#)">M</button>
                                <h6 class="slt-padding"><span>#LANG#</span></h6>
                            </div>				
                            <div id="moduleSubElementsTr#MODULE_ID#" class="text-left" style="display:none;margin-top:0.65em;margin-bottom:0.65em;">            	
                                <div id = "moduleSubElementsDiv#MODULE_ID#"></div>            
                            </div>
                        </li>
                    </cfoutput>
                </ul>
            </div>
    </cfcase>
    <cfcase value="3">
        <cfquery name="getObjects" datasource="#dsn#">
        	SELECT
            	WIS.*,
                S.ITEM_#UCase(session.ep.language)#
            FROM
            	WRK_IMPLEMENTATION_STEP AS WIS
                LEFT JOIN SETUP_LANGUAGE_TR AS S ON S.DICTIONARY_ID = WIS.WRK_IMPLEMENTATION_TASK
                LEFT JOIN WRK_MODULE AS WM ON WIS.WRK_MODUL_ID = WM.MODULE_NO
            WHERE
            	WM.MODULE_ID = #attributes.id#
                --AND W.IS_MENU = 1
            ORDER BY
            	ISNULL(WIS.RANK_NUMBER,100),
            	S.ITEM_#UCase(session.ep.language)#
        </cfquery>
         <div class="cl-12 cl-xs-12 sltdiv">
            <ul class="list-group" id="sorterModule">
                    <li class="list-group-sub" id="wrkModule">
                        <div class="cl-12 cl-xs-12" style="padding:0;">
                            <!---<button type="button" class="btn btn-dark btn-sm slt-btn">T</button>--->
                                <table class="table table-hover">
                                    <cfif getObjects.recordcount gt 0>
                                    <thead>
                                        <tr>
                                        <th>N/C</th>
                                        <th>Task</th>
                                        <th>Solution / Family / Module</th>
                                        <th>Help</th>
                                        <th>Link (WO)</th>
                                        <th>Related WBO</th>
                                        <th>Record</th>                                       
                                        <th>BP</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <cfoutput query="getObjects">
                                            <cfif len(getObjects.WRK_RELATED_TABLE_NAME) and len(getObjects.WRK_RELATED_SCHEMA_NAME)>
                                                <cfif getObjects.WRK_RELATED_SCHEMA_NAME eq 'dsn'><cfset dsn = "#dsn#">
                                                <cfelseif getObjects.WRK_RELATED_SCHEMA_NAME eq 'dsn1'><cfset dsn = "#dsn1#">
                                                <cfelseif getObjects.WRK_RELATED_SCHEMA_NAME eq 'dsn2'><cfset dsn = "#dsn2#">
                                                <cfelseif getObjects.WRK_RELATED_SCHEMA_NAME eq 'dsn3'><cfset dsn = "#dsn3#">
                                                </cfif>
                                                <cfquery name="GET_TABLE_COUNT" datasource="#dsn#">
                                                    SELECT COUNT(*) AS TOTAL FROM #getObjects.WRK_RELATED_TABLE_NAME#
                                                </cfquery>
                                            </cfif>
                                            <tr>
                                            <td><label class="switch"><input type="checkbox" onclick="updStatus('#WRK_IMPLEMENTATION_STEP_ID#','#WRK_IMPLEMENTATION_TASK_COMPLETE#')" <cfif WRK_IMPLEMENTATION_TASK_COMPLETE eq 1>checked</cfif>><span class="slider round"></span></label></td>
                                            <td>#ITEM_TR#</td>
                                            <td style="vertical-align:middle;"><i class="fa fa-question-circle-o"></i></td>
                                            <td><a href="/index.cfm?fuseaction=#WRK_OBJECTS#" target="_blank"><i class="fa fa-link"></i></a></td>
                                            <td><h6>
                                                <cfif len(getObjects.WRK_RELATED_TABLE_NAME) and len(getObjects.WRK_RELATED_SCHEMA_NAME)>
                                                <span class="badge badge-pill badge-info">
                                                #GET_TABLE_COUNT.TOTAL#</span>
                                                </cfif></h6>
                                            </td>
                                            <td><cfloop from="1" to="#listlen(wrk_related_objects)#" index="i">
                                                    <cfset tut = #listgetat(WRK_RELATED_OBJECTS,#i#,',')#>
                                                    <a href="/index.cfm?fuseaction=#tut#" target="_blank">#left(tut,len(tut))#</a>
                                                </cfloop>
                                            </td>
                                            <td><i class="fa fa-spinner" data-toggle="modal" data-target="##exampleModalCenter"></i></td>
                                            </tr>
                                        </cfoutput>
                                    </tbody>
                                    <cfelse>
                                        <h6>Henüz bir task tanımı yapılmamış.</h6>
                                    </cfif>
                                </table>
                        </div>				                                                        
                    </li>
            </ul>
        </div>
    </cfcase>
</cfswitch>


       
               
    