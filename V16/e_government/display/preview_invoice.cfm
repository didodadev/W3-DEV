<!---
    File: preview_invoice.cfm
    Folder: V16\e_government\display\
    Author: Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
    Date: 2019-12-07 23:51:14 
    Description:
        E-fatura ve E-arşiv fatura ön izleme için kullanılır.
        E-arşiv faturada V16\e_government\display\create_xml_earchive.cfm dosyası içerisinde V16\e_government\display\earchive_dp.cfm dosyası include ediliyor, değerler bu dosyadan geliyor.
        
        Ref: https://www.w3schools.com/xml/xsl_client.asp

        Şuraya bir not düşelim:
        Bir bozuk saattir yüreğim, hep sende durur...
        Turgut Uyar
        #şiirsokakta

    History:
        
    To Do:

--->

<cfsavecontent variable="head_text">
<title><cf_get_lang dictionary_id='44564.Önizleme'></title>
</cfsavecontent>
<cfhtmlhead text="#head_text#" />

<cfif attributes.invoice_type Eq 'earchieve'>
    <cfinclude template="create_xml_earchive.cfm" />
<cfelse>
    <cfinclude template="create_xml.cfm" />
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
        xml = loadXMLDoc("<cfoutput>#preview_invoice_xml#</cfoutput>");
        xsl = loadXMLDoc("<cfoutput>#preview_invoice_template#</cfoutput>");
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