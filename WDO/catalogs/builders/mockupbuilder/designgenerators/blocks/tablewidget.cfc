<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.widget">

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>
            tableStruct = getTable(this.data.listOfElements[1]);
            head = ident(this.identcount + 1) & '<thead>' & crlf() & ident(this.identcount + 2) & '<tr>';
            body = ident(this.identcount + 1) & '<tbody>';
            body = body & crlf() & ident(this.identcount + 2) & '<c' & 'fif isDefined("' & tableStruct.name & '_query")>';
            body = body & crlf() & ident(this.identcount + 2) & '<c' & 'fset ' & tableStruct.name & '_index = 0>';
            body = body & crlf() & ident(this.identcount + 2) & '<c' & 'foutput query="' & tableStruct.name & '_query">';
            body = body & crlf() & ident(this.identcount + 2) & '<tr data-rowindex="##' & tableStruct.name & '_index##">';

            languagegenerator = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.languagegenerator");

            elmindex = 1;
            for (element in this.data.listOfElements) {
                
                modelElement = getElement(element);
                headline = "";
                bodyline = "";
                //hide table column for hidden field
                if ( modelElement.fieldType neq "Hidden Input" ) {
                    headline = crlf() & ident(this.identcount + 3) & '<th>' & languagegenerator.generate(modelElement.langNo) & '</th>';
                    bodyline = crlf() & ident(this.identcount + 3) & '<td>' & crlf();
                }

                if (getRowType(element) eq "Add Row" && this.data.editMode neq "none")
                {
                    eventattr = [];
                    if (this.data.editMode neq "none")
                    {
                        eventattrbuilder = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.events.fieldeditorevent");
                        eventattr = eventattrbuilder.getAttributes(element, this.domain, this.data.editMode);
                    }
                    
                    inputwidget = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.inputfactory").create(modelElement.fieldType, element, this.domain, this.eventtype, this.identcount + 4, eventattr, '##' & tableStruct.name & '_index##', "formelements", 0);

                    generatedcode = replace( inputwidget.generate(), "{index}", '##' & tableStruct.name & '_index##', 'all' );

                    //bodyline = bodyline & ident(this.identcount + 4) & "<c" & 'fif isDefined("editableGrid") && editableGrid("' & element.label & '")>' & crlf();
                    bodyline = bodyline & ident(this.identcount + 4) & generatedcode & crlf();
                    //bodyline = bodyline & ident(this.identcount + 4) & "<c" & 'felse>' & crlf();
                    //bodyline = bodyline & ident(this.identcount + 4) & "##" & element.label & "##" & crlf();
                    //bodyline = bodyline & ident(this.identcount + 4) & "</cfif>" & crlf();
                }
                else
                {
                    bodyline = bodyline & "##" & element.label & "##";
                }
                //hide table column for hidden field
                if ( modelElement.fieldType neq "Hidden Input" ) {
                    bodyline = bodyline & ident(this.identcount + 3) & '</td>' & crlf();
                    head = head & headline & crlf();
                }

                body = body & bodyline & crlf();
                elmindex = elmindex + 1;
            }

            if (getRowType(this.data.listOfElements[1]) eq "Add Row" && this.data.editMode eq "row")
            {
                head = head & ident(this.identcount + 3) & '<th>' & languagegenerator.generate( 1 ) & '</th>';
                //body = body & ident(this.identcount + 3) & '<td><button type="button" onclick="gridUpdater($(this).closest(''tr'')), ''' & this.data.listOfElements[1].struct & ''', ''row'')">' & languagegenerator.generate(1) & '</button></td>';
            }
            else if (getRowType(this.data.listOfElements[1]) eq "Add Row" && this.data.editMode eq "table")
            {

                head = head & ident(this.identcount + 3) & '<th><a href="javascript:void(0)" onclick="' & tableStruct.name & '_addrow(this)"><i class="fa fa-plus" style="color:grey;"></i></a></th>';
                body = body & ident(this.identcount + 3) & '<td><a href="javascript:void(0)" onclick="' & tableStruct.name & '_remrow(this)"><i class="fa fa-minus" style="color:grey"></i></a></td>';
                //bodyafter = '<tr><td colspan="' & (arrayLen(this.data.listOfElements) + 1) & '"><button type="button" onclick="gridUpdater($(this).closest(''table''), ''' & this.data.listOfElements[1].struct & ''', ''table'')">' & languagegenerator.generate(1) & '</button></td></tr>';
            }

            head = head & crlf() & ident(this.identcount + 2) & '</tr>' & crlf() & ident(this.identcount + 1) & '</thead>';
            body = body & crlf() & ident(this.identcount + 2) & '</tr>';
            body = body & crlf() & ident(this.identcount + 2) & '<c' & 'fset ' & tableStruct.name & '_index++>';
            body = body & crlf() & ident(this.identcount + 2) & '</c' & "foutput>";
            body = body & crlf() & ident(this.identcount + 2) & '</cfif>';
            if (isDefined("bodyafter")) body = body & crlf() & ident(this.identcount + 2) & bodyafter;
            body = body & crlf() & ident(this.identcount + 1) & '</tbody>';

            
            //tablecode = '<style>.table .input-group .input-group-addon {display: block;} .table .input-group input {display: inline-block;}</style>' & crlf();
            tablecode = ident() & '<table class="ajax_list form-group" data-formulasummary="false">' & crlf();
            tablecode = tablecode & head & crlf() & body & crlf() & ident() & '</table>';

            if (arrayLen(tableStruct.listOfSummaries))
            {
                summaryWidget = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.blocks.summarywidget").init(tableStruct.listOfSummaries, this.domain, this.identcount);
                summaryCode = summaryWidget.generate();
                tablecode = tablecode & crlf() & summaryCode;
            }

            if (getRowType(this.data.listOfElements[1]) eq "Add Row")
            {
                tablecode = tablecode & crlf() & ident(this.identcount + 1) & '<script type="text/javascript">';
                tablecode = tablecode & crlf() & ident(this.identcount + 2) & 'function ' & tableStruct.name & '_addrow(ref) {';
                tablecode = tablecode & crlf() & ident(this.identcount + 2) & 'var appendData = `' & this.template() & '`;';
                if (this.data.editMode eq "table") 
                {
                    tablecode = tablecode & crlf() & ident(this.identcount + 2) & 'var nanodata = { index: $(ref).closest("table").find("tbody tr").length };';
                    tablecode = tablecode & crlf() & ident(this.identcount + 2) & 'if ($(ref).closest("table").find("tbody tr").last().length == 0) {';
                    tablecode = tablecode & crlf() & ident(this.identcount + 3) & '$(ref).closest("table").find("tbody").append(nano(appendData, nanodata));';
                    tablecode = tablecode & crlf() & ident(this.identcount + 2) & '} else {';
                    tablecode = tablecode & crlf() & ident(this.identcount + 3) & '$(ref).closest("table").find("tbody tr").last().after(nano(appendData, nanodata));';
                    tablecode = tablecode & crlf() & ident(this.identcount + 2) & '}';
                }
                else if (this.data.editMode eq "row")
                {
                    tablecode = tablecode & crlf() & ident(this.identcount + 2) & 'var nanodata = { index: $(ref).closest("table").find("tbody tr").length + 1 };';
                    tablecode = tablecode & crlf() & ident(this.identcount + 2) & '$(ref).closest("table").find("tbody").append(nano(appendData, nanodata));';
                }
                tablecode = tablecode & crlf() & ident(this.identcount + 2) & 'formulaObserver.get("' & tableStruct.name & '").rebind();';
                tablecode = tablecode & crlf() & ident(this.identcount + 2) & '}';
                tablecode = tablecode & crlf() & ident(this.identcount + 2) & 'function ' & tableStruct.name & '_remrow(ref) {';
                tablecode = tablecode & crlf() & ident(this.identcount + 3) & '$(ref).parent().parent().remove();';
                tablecode = tablecode & crlf() & ident(this.identcount + 3) & 'formulaObserver.get("' & tableStruct.name & '").rebind();';
                tablecode = tablecode & crlf() & ident(this.identcount + 2) & '}';
                tablecode = tablecode & crlf() & ident(this.identcount + 1) & '</script>';
            }

        </cfscript>
        <cfreturn tablecode>
    </cffunction>

    <cffunction name="template" access="public" returntype="string">
        <cfscript>
            body = '<tr data-rowindex="{index}">';
            for (element in this.data.listOfElements) {
                
                modelElement = getElement(element);
                bodyline = "";
                if ( modelElement.fieldType neq "Hidden Input" ) {
                    bodyline = '<td>';
                }
            
                eventattr = [];
                
                eventattrbuilder = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.events.fieldeditorevent");
                eventattr = eventattrbuilder.getAttributes(element, this.domain, this.data.editMode);
                
                inputwidget = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.inputfactory").create(modelElement.fieldType, element, this.domain, this.eventtype, 0, eventattr, "{index}");

                bodyline = bodyline & inputwidget.generate("");
                
                if ( modelElement.fieldType neq "Hidden Input" ) {
                    bodyline = bodyline & '</td>';
                }
                body = body & bodyline;
            }
            if (getRowType(this.data.listOfElements[1]) eq "Add Row" && this.data.editMode eq "row")
            {
                body = body & '<td><a href="javascript:void(0)" onclick="gridUpdater($(this).closest(''tr'')), ''' & this.data.listOfElements[1].struct & ''', ''row'')">' & languagegenerator.generate(1) & '</a></td>';
            } else {
                body = body & ident(this.identcount + 3) & '<td><a href="javascript:void(0)" onclick="' & tableStruct.name & '_remrow(this)"><i class="fa fa-minus" style="color:grey"></i></a></td>';
            }
            body = body &"</tr>";
        </cfscript>
        <cfreturn body>
    </cffunction>

    <cffunction name="getRowType" access="private" returntype="any">
        <cfargument name="element" type="any">
        <cfscript>
            table = getTable(element);
            result = table.template;
        </cfscript>
        <cfreturn result>
    </cffunction>

    <cffunction name="getTable" access="private" returntype="any">
        <cfargument name="element" type="any">
        <cfscript>
            stk = arguments.element.struct;
            stck = this.domain[arrayFind(this.domain, function(elm) {
                return elm.name eq stk;
            })];
        </cfscript>
        <cfreturn stck>
    </cffunction>

    <cffunction name="getElement" access="private" returntype="any">
        <cfargument name="element" type="any">
        <cfscript>
            stk = arguments.element.struct;
            lbl = arguments.element.label;
            stck = this.domain[arrayFind(this.domain, function(elm) {
                return elm.name eq stk;
            })];
            result = stck.listOfElements[arrayFind(stck.listOfElements, function(elm) {
                return elm.label eq lbl;
            })];
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>