<cfcomponent extends="WDO.catalogs.builders.mockupbuilder.mockup">

    <cfproperty name="uniqueid" type="string">
    <cfproperty name="languageGenerator" type="any">

    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="queryparams">

        <cfset this.uniqueid = randRange(10000,99999)>
        <cfscript>
            resultformat = crlf() & ident() & '<c' & 'anvas id="piewidget_' & this.uniqueid & '" style="width: 100%"></canvas>';
            resultformat = resultformat & crlf() & ident() & '<s' & 'cript type="text/javascript">';
            resultformat = resultformat & crlf() & ident() & '$(document).ready(function() {';
            resultformat = resultformat & crlf() & ident( this.identcount + 1 ) & 'var piecontext_' & this.uniqueid & ' = document.getElementById("piewidget_' & this.uniqueid & '").getContext("2d");';
            resultformat = resultformat & crlf() & ident( this.identcount + 1 ) & 'var piechart_' & this.uniqueid & ' = new Chart(piecontext_' & this.uniqueid & ', {';
            resultformat = resultformat & crlf() & ident( this.identcount + 2 ) & 'type: "pie",';
            resultformat = resultformat & crlf() & ident( this.identcount + 2 ) & 'data: {';
            resultformat = resultformat & crlf() & ident( this.identcount + 3 ) & 'labels: ' & getlabels() & ',';
            resultformat = resultformat & crlf() & ident( this.identcount + 3 ) & 'datasets: [' & getdatasets() & ']';
            resultformat = resultformat & crlf() & ident( this.identcount + 2 ) & '},';
            resultformat = resultformat & crlf() & ident( this.identcount + 2 ) & 'options: { responsive: true }';
            resultformat = resultformat & crlf() & ident( this.identcount + 1 ) & '});';
            resultformat = resultformat & crlf() & ident() & '});';
            resultformat = resultformat & crlf() & ident() & '</script>';
        </cfscript>
    </cffunction>

    <cffunction name="getlabels" returntype="string">
        <cfscript>
            result = '<c' & 'fscript>';
            result = result & crlf() & ident( this.identcount + 2 ) & 'axislabels = arrayNew(1);';
            result = result & crlf() & ident( this.identcount + 2 ) & 'for( i=1; i<=ArrayLen('&this.data.listOfAxis[1]&'); i++ ) {';
            result = result & crlf() & ident( this.identcount + 3 ) & 'arrayAppend(axislabels, ' & this.data.listOfAxis[1].label & ');';
            result = result & crlf() & ident( this.identcount + 2 ) & '}';
            result = result & crlf() & ident( this.identcount + 2 ) & 'writeOutput(replace(serializeJSON(axislabels),"//",""));';
            result = result & crlf() & ident( this.identcount + 1 ) & '</cfscript>';
            return result;
        </cfscript>
    </cffunction>

    <cffunction name="getdatasets" returntype="string">
        <cfscript>
            if ( not isDefined( "this.languageGenerator" ) )
                this.languaGegenerator = createObject("component", "WDO.catalogs.builders.mockupbuilder.designgenerators.languagegenerator");
            
            axisnames = arrayMap( this.data.listOfSummaries, function( elm ) {
                return "'" & this.languageGenerator.generate( elm.langNo ) & " " & elm.graphMethod & "'";
            });
            axiscolors = arrayMap( this.data.listOfSummaries, function( elm ) {
                axiscolorformat = '<c' & 'fscript>';
                axiscolorformat = axiscolorformat & crlf() & ident( this.identcount + 3 ) & 'axiscolors = arrayNew(1);';
                axiscolorformat = axiscolorformat & crlf() & ident( this.identcount + 4 ) & 'for( i=1; i<=ArrayLen(' & this.data.listOfSummaries & '); i++ ) {';
                axiscolorformat = axiscolorformat & crlf() & ident( this.identcount + 5 ) & 'arrayAppend(axiscolors, ' & "'rgba(##randRange(1, 255)##,##randRange(1, 255)##,##randRange(1, 255)##, 0.6)'" & ');';
                axiscolorformat = axiscolorformat & crlf() & ident( this.identcount + 4 ) & '}';
                axiscolorformat = axiscolorformat & crlf() & ident( this.identcount + 4 ) & 'writeOutput(replace(serializeJSON(axiscolors),"//",""));';
                axiscolorformat = axiscolorformat & crlf() & ident( this.identcount + 3 ) & '</cfscript>';
                return axiscolorformat;
            });
            axisdatas = arrayMap( this.data.listOfSummaries, function( elm ) {
                axisdataformat = '<c' & 'fscript>';
                axisdataformat = axisdataformat & crlf() & ident( this.identcount + 4 ) & 'axisdatas = arrayNew(1);';
                axisdataformat = axisdataformat & crlf() & ident( this.identcount + 4 ) & 'for( i=1; i<=ArrayLen(' & this.data.listOfSummaries & '); i++ ) {';
                axisdataformat = axisdataformat & crlf() & ident( this.identcount + 5 ) & 'arrayAppend(axisdatas, elm.label);';
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