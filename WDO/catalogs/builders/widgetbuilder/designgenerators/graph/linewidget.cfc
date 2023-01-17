<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">

    <cfproperty name="uniqueid" type="string">
    <cfproperty name="languageGenerator" type="any">

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="queryparams">
        <cfset this.uniqueid = randRange(10000,99999)>
        <cfscript>
            getWidgetDependencyManager().addDependency( dependStruct: this.data.listOfSummaries[1].struct, dependEvent: this.eventtype );
            querystr = generate_query(arguments.queryparams);
            resultformat = crlf() & ident() & '<c' & 'anvas id="linewidget_' & this.uniqueid & '" style="width: 100%"></canvas>';
            resultformat = resultformat & crlf() & ident() & '<s' & 'cript type="text/javascript">';
            resultformat = resultformat & crlf() & ident() & '$(document).ready(function() {';
            resultformat = resultformat & crlf() & ident( this.identcount + 1 ) & 'var linecontext_' & this.uniqueid & ' = document.getElementById("linewidget_' & this.uniqueid & '").getContext("2d");';
            resultformat = resultformat & crlf() & ident( this.identcount + 1 ) & 'var linechart_' & this.uniqueid & ' = new Chart(linecontext_' & this.uniqueid & ', {';
            resultformat = resultformat & crlf() & ident( this.identcount + 2 ) & 'type: "line",';
            resultformat = resultformat & crlf() & ident( this.identcount + 2 ) & 'data: {';
            resultformat = resultformat & crlf() & ident( this.identcount + 3 ) & 'labels: ' & getlabels() & ',';
            resultformat = resultformat & crlf() & ident( this.identcount + 3 ) & 'datasets: [' & getdatasets() & ']';
            resultformat = resultformat & crlf() & ident( this.identcount + 2 ) & '},';
            resultformat = resultformat & crlf() & ident( this.identcount + 2 ) & 'options: { responsive: true }';
            resultformat = resultformat & crlf() & ident( this.identcount + 1 ) & '});';
            resultformat = resultformat & crlf() & ident() & '});';
            resultformat = resultformat & crlf() & ident() & '</script>';
            return querystr & resultformat;
        </cfscript>
    </cffunction>

    <cffunction name="generate_query" returntype="string">
        <cfargument name="queryparams">
        <cfscript>
            masterquery = crlf() & ident() & '<c' & 'fset linequery_master_' & this.uniqueid & ' = ' & this.data.listOfSummaries[1].struct & "_query( [%s] )>";
            masterquery_array = arrayNew(1);
            for (qp in queryparams) {
                strparam = "{ %s }";
                strparam_array = arrayNew(1);
                for (qpkey in structKeyArray(qp)) {
                    qpstr = qpkey & ":" & ( qpKey eq "label" and qp.isEval eq 1 ? qp[qpkey] : "'" & qp[qpkey] & "'");
                    arrayAppend(strparam_array, qpstr);
                }
                arrayAppend(masterquery_array, stringFormat( strparam, [arrayToList(strparam_array)] ) );
            }
            masterquery = stringFormat( masterquery, [arrayToList(masterquery_array)] );
            queryformat = crlf() & ident() & '<c' & 'fquery name="linequery_' & this.uniqueid & '" dbtype="query">' & crlf() & ident(this.identcount + 1) & 'SELECT %s FROM %s GROUP BY %s' & crlf() & ident() & '</cfquery>';
            groups = arrayToList( arrayMap( this.data.listOfAxis, function( elm ) {
                return elm.label;
            } ) );
            summaries = arrayToList( arrayMap( this.data.listOfSummaries, function( elm ) {
                return elm.graphMethod & "(" & elm.label & ") AS " & elm.label;
            }) );
            return masterquery & stringFormat( queryformat, [ groups & "," & summaries, "linequery_master_" & this.uniqueid, groups ] );

        </cfscript>
    </cffunction>

    <cffunction name="getlabels" returntype="string">
        <cfscript>
            result = '<c' & 'fscript>';
            result = result & crlf() & ident( this.identcount + 2 ) & 'axislabels = arrayNew(1);';
            result = result & crlf() & ident( this.identcount + 2 ) & 'for( i=1; i<=linequery_' & this.uniqueid & '.recordCount; i++ ) {';
            result = result & crlf() & ident( this.identcount + 3 ) & 'arrayAppend(axislabels, ##linequery_' & this.uniqueid & '["' & this.data.listOfAxis[1].label & '"][i]##);';
            result = result & crlf() & ident( this.identcount + 2 ) & '}';
            result = result & crlf() & ident( this.identcount + 2 ) & 'writeOutput(replace(serializeJSON(axislabels),"//",""));';
            result = result & crlf() & ident( this.identcount + 1 ) & '</cfscript>';
            return result;
        </cfscript>
    </cffunction>

    <cffunction name="getdatasets" returntype="string">
        <cfscript>
            if ( not isDefined( "this.languageGenerator" ) )
                this.languaGegenerator = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.languagegenerator");
            
            axisnames = arrayMap( this.data.listOfSummaries, function( elm ) {
                return "'" & this.languageGenerator.generate( elm.langNo ) & " " & elm.graphMethod & "'";
            });

            axiscolors = arrayMap( this.data.listOfSummaries, function( elm ) {
                axiscolorformat = '<c' & 'fscript>';
                axiscolorformat = axiscolorformat & crlf() & ident( this.identcount + 3 ) & 'axiscolors = arrayNew(1);';
                axiscolorformat = axiscolorformat & crlf() & ident( this.identcount + 4 ) & 'for( i=1; i<=linequery_' & this.uniqueid & '.recordCount; i++ ) {';
                axiscolorformat = axiscolorformat & crlf() & ident( this.identcount + 5 ) & 'arrayAppend(axiscolors, ' & "'rgba(#randRange(1, 255)#,#randRange(1, 255)#,#randRange(1, 255)#, 0.6)'" & ');';
                axiscolorformat = axiscolorformat & crlf() & ident( this.identcount + 4 ) & '}';
                axiscolorformat = axiscolorformat & crlf() & ident( this.identcount + 4 ) & 'writeOutput(replace(serializeJSON(axiscolors),"//",""));';
                axiscolorformat = axiscolorformat & crlf() & ident( this.identcount + 3 ) & '</cfscript>';
                return axiscolorformat;
            });
            axisdatas = arrayMap( this.data.listOfSummaries, function( elm ) {
                axisdataformat = '<c' & 'fscript>';
                axisdataformat = axisdataformat & crlf() & ident( this.identcount + 4 ) & 'axisdatas = arrayNew(1);';
                axisdataformat = axisdataformat & crlf() & ident( this.identcount + 4 ) & 'for( i=1; i<=linequery_' & this.uniqueid & '.recordCount; i++ ) {';
                axisdataformat = axisdataformat & crlf() & ident( this.identcount + 5 ) & 'arrayAppend(axisdatas, ##linequery_' & this.uniqueid & '["' & elm.label & '"][i]##);';
                axisdataformat = axisdataformat & crlf() & ident( this.identcount + 4 ) & '}';
                axisdataformat = axisdataformat & crlf() & ident( this.identcount + 4 ) & 'writeOutput(replace(serializeJSON(axisdatas),"//",""));';
                axisdataformat = axisdataformat & crlf() & ident( this.identcount + 3 ) & '</cfscript>';
                return axisdataformat;
            });
            axisdatasets = [];
            for ( axi = 1; axi <= arrayLen( this.data.listOfSummaries ); axi++ ) {
                arrayAppend( axisdatasets, '{label:' & axisnames[axi] & ', backgroundColor: ' & axiscolors[axi] & ', data:' & axisdatas[axi] & '}' );
            }
            return arrayToList( axisdatasets, ',' );
            
        </cfscript>
    </cffunction>

</cfcomponent>