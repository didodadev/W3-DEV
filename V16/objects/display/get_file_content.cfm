<cfparam name = "attributes.file_path" default="" />

<cfif len( attributes.file_path )>

    <link rel="stylesheet" href="/css/assets/template/codemirror/codemirror.css">
    <script type="text/javascript" src="/JS/codemirror/codemirror.js"></script>
    <script type="text/javascript" src="/JS/codemirror/simplescrollbars.js"></script>
    <script type="text/javascript" src="/JS/codemirror/sql.js"></script>

    <cfscript>
        content = fileRead(attributes.file_path,'UTF-8');
    </cfscript>

    <textarea id='text_file_content'><cfoutput>#content#</cfoutput></textarea>

    <script>
        var content = document.getElementById("text_file_content");
        var editor = CodeMirror.fromTextArea(content, {
            mode: "text/x-sql",
            lineNumbers: true
        });
    </script>

</cfif>