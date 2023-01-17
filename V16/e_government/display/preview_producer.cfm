<!--- E-makbuz Önizleme ara sayfa olarak kullanılır --->

<cfsavecontent variable="head_text">
    <title><cf_get_lang dictionary_id='44564.Önizleme'></title>
    </cfsavecontent>
    <cfhtmlhead text="#head_text#" />
        <cfif attributes.action_type eq 'MM'> <!--- müstahsil makbuzu --->
            <cfinclude template="create_xml_eproducer_receipt.cfm" />
        <cfelseif attributes.action_type eq 'SMM'> <!--- serbest meslek makbuzu --->
            <cfinclude template="create_xml_evoucher.cfm" />
        </cfif>

    <div id="preview_invoice" />
    
    <script type="text/javascript">
        function loadXMLDoc(filename) {
            if (window.ActiveXObject) {
                xhttp = new ActiveXObject("Msxml2.XMLHTTP");
            }
            else {
                xhttp = new XMLHttpRequest();
            }
            xhttp.open("GET", filename, false);
            try { xhttp.responseType = "msxml-document" } catch (err) { } // Helping IE11
            xhttp.send("");
            return xhttp.responseXML;
        }
    
        function displayResult() {
            xml = loadXMLDoc("<cfoutput>#preview_receipt_xml#</cfoutput>");
            console.log(xml);
            xsl = loadXMLDoc("<cfoutput>#preview_producer_template#</cfoutput>");
            console.log(xsl);
            // code for IE
            if (window.ActiveXObject || xhttp.responseType == "msxml-document") {
                ex = xml.transformNode(xsl);
                document.getElementById("preview_invoice").innerHTML = ex;
            }
            // code for Chrome, Firefox, Opera, etc.
            else if (document.implementation && document.implementation.createDocument) {
                xsltProcessor = new XSLTProcessor();
                xsltProcessor.importStylesheet(xsl);
                resultDocument = xsltProcessor.transformToFragment(xml, document);
                document.getElementById("preview_invoice").appendChild(resultDocument);
            }
        }
    
        $(document).ready(function(){
            displayResult();
        });
    
        $(document).keydown(function(e){
            // ESCAPE key pressed
            if (e.keyCode == 27) {
                window.close();
            }
        });
    </script>