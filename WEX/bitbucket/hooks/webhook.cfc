<cfcomponent hint="Bitbucket web hooks">

    <cffunction name="init" access="public">
    </cffunction>
    
    <cffunction name="ap" access="public">
        <cfargument name="data">

        <cftry>

        <cfif isDefined("data.pullrequest")>
            <cfreturn pullrequest(arguments.data)>
        </cfif>

        <cfcatch>
            <cfreturn result(0, "", cfcatch)>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="pullrequest" access="private">
        <cfargument name="data">

        <cftry>

        <cfscript>
            title = data.pullrequest.title;
            description = data.pullrequest.rendered.description.html;
            task_id = 0;
            view_url = data.pullrequest.links.html.href;
            author = data.pullrequest.author.display_name;
            author_data = replace(serializeJSON(data.pullrequest.author), "//", "");
            created = data.pullrequest.created_on;
            bbid = data.pullrequest.id;
            destination_branch = data.pullrequest.destination.branch.name;
            source_branch = data.pullrequest.source.branch.name;
            state = data.pullrequest.state;
            participants = "";

            if (isDefined("data.pullrequest.participants")) {
                participants = replace(serializeJSON(data.pullrequest.participants), "//", "");
            }

            processid_found = reFind("##\d+", title, 1, 'yes');
            if (processid_found.len[1] eq 0) {
                processid_found = reFind("##\d+", description, 1, 'yes');
            }
            if (processid_found.len[1] gt 0) {
                task_id = mid(processid_found.match[1], 2, 25);
            }

        </cfscript>

        <cfobject name="bbdata" type="component" component="WEX.bitbucket.components.data">

        <cfset bbdata.insert( title, description, task_id, view_url, author, author_data, created, bbid, destination_branch, source_branch, state, participants )>
        
        <cfcatch>
            <cfreturn result(0, "", cfcatch)>
        </cfcatch>
        </cftry>

        <cfreturn result(1)>
        
    </cffunction>

    <cffunction name="result">
        <cfargument name="status">
        <cfargument name="message" default="">
        <cfargument name="obj" default="">

        <cfscript>
            resultobj = structNew();
            resultobj.status = arguments.status;
            if (len(message)) {
                resultobj.message = arguments.message;
            }
            if (len(obj)) {
                resultobj.obj = arguments.obj;
            }
        </cfscript>

        <cfreturn serializeJSON(resultobj, 'yes', 'no')>        
    </cffunction>

</cfcomponent>