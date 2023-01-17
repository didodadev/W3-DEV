<cfset getComponent = createObject('component','V16.process.cfc.get_design')>
<!-----<script>
    var text, parser, xmlDoc;
    text = <cfoutput>'#URLDecode(attributes.xml)#'</cfoutput>;
    parser = new DOMParser();
    xmlDoc = parser.parseFromString(text,"text/xml");
    xmlToJson(xmlDoc);
    function xmlToJson(xml) {
        // Create the return object
        var obj = {};
        if (xml.nodeType == 1) { // element
            // do attributes
            if (xml.attributes.length > 0) {
            obj = {};
                for (var j = 0; j < xml.attributes.length; j++) {
                    var attribute = xml.attributes.item(j);
                    obj[attribute.nodeName] = attribute.nodeValue;
                }
            }
        } else if (xml.nodeType == 3) { // text
            obj = xml.nodeValue;
        }
        // do children
        if (xml.hasChildNodes()) {
            for(var i = 0; i < xml.childNodes.length; i++) {
                var item = xml.childNodes.item(i);
                var nodeName = item.nodeName;
                if (typeof(obj[nodeName]) == "undefined") {
                    obj[nodeName] = xmlToJson(item);
                } else {
                    if (typeof(obj[nodeName].length) == "undefined") {
                        var old = obj[nodeName];
                        obj[nodeName] = [];
                        obj[nodeName].push(old);
                    }
                    obj[nodeName].push(xmlToJson(item));
                }
            }
        }
        console.log(obj);
    };
</script>---->
<!----type göre query çalıştırılacak---->
<cfif isdefined('attributes.event') and len(attributes.event) and attributes.event eq 'concept'>
    <cfif isdefined('attributes.id') and len(attributes.id)>
        <cfset add_design = getComponent.UPD_WRK_SESSION_TO_DB(
            xml : '#iif(isdefined("attributes.xml"),"attributes.xml",DE(""))#',
            filename : '#iif(isdefined("attributes.filename"),"attributes.filename",DE(""))#',
            c_id : attributes.id
        )>
        <script type="text/javascript">
            window.location.href='<cfoutput>#request.self#?fuseaction=process.designer&event=concept&id=#attributes.id#</cfoutput>';
        </script>
    <cfelse>
        <cfset add_design = getComponent.ADD_WRK_SESSION_TO_DB(
            xml : '#iif(isdefined("attributes.xml"),"attributes.xml",DE(""))#',
            filename : '#iif(isdefined("attributes.filename"),"attributes.filename",DE(""))#',
            type : 'concept',
            action_section : #iif(isdefined("url.action_section"),"url.action_section",DE(""))#,
            relative_id : #iif(isdefined("url.relative_id"),"url.relative_id",DE(""))#
        )>
        <cfset get_last_id = getComponent.GET_LAST_ID()>
        <script type="text/javascript">
            location.href=document.referrer;
            window.location.href='<cfoutput>#request.self#?fuseaction=process.designer&event=concept&id=#get_last_id.max_id#</cfoutput>';
        </script>
    </cfif>
    
   <cfabort>
<cfelseif isdefined('attributes.event') and len(attributes.event) and attributes.event eq 'main'>
    <cfset add_design = getComponent.ADD_MAIN_DESIGNER(
        xml : '#iif(isdefined("attributes.xml"),"attributes.xml",DE(""))#',
        filename : '#iif(isdefined("attributes.filename"),"attributes.filename",DE(""))#',
        type : 'main',
        main_process_id : '#iif(isdefined("attributes.main_process_id"),"attributes.main_process_id",DE(""))#'
    )>
<cfelseif isdefined('attributes.event') and len(attributes.event) and attributes.event eq 'sub'>
    <script>
        alert('<cfoutput>#attributes.event# : sub</cfoutput>');
    </script>
</cfif>