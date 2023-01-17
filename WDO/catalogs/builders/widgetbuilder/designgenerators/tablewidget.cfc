<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.widget">
    
    <cffunction name="generatefilter" access="public" returntype="string">
        <cfargument name="indata" type="any">
        <cfargument name="struct" type="any">
        <cfscript>
            
            result = ident( this.identcount + 4 ) & '<input type="hidden" name="searched" value="1">' & crlf();
            for( condition in indata )
            {
                if ( condition.type eq "Expression" && condition.isList eq "1" )
                {
                    fgwidget = createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.filterinputgroupwidget" ).init( data:condition, domain:this.domain, identcount:this.identcount + 4, eventtype:'list' );
                    result = result & fgwidget.generate( arguments.struct ) & crlf();
                }
            }
            
        </cfscript>
        <cfreturn result>
    </cffunction>

    <cffunction name="generatesearch" access="public" returntype="string">
        <cfscript>
            result = ident(this.identcount + 2);
            
            for ( row in this.data.listLayout.search.layout ) 
            {
                rowwidget = createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.searchwidgets.rowwidget" ).init( data:row, domain:this.domain, eventtype: 'list', identcount:this.identcount + 2 );
                result = result & rowwidget.generate() & crlf();
            }
        </cfscript>
        <cfreturn result>
    </cffunction>

    <cffunction name="generate" access="public" returntype="string">
        <cfscript>

            stck = this.domain[ arrayFind( this.domain, function( elm ) {
                return elm.name eq this.data.listLayout.layout[ 1 ].struct;
            } ) ];

            pagerbeforetemplate = '<cfparam name="attributes.page" default="1">' & crlf();
            pagerbeforetemplate = pagerbeforetemplate & '<cfparam name="attributes.maxrows" default="##session.ep.maxrows##">' & crlf();
            pagerbeforetemplate = pagerbeforetemplate & '<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>' & crlf();
            pagerbeforetemplate = pagerbeforetemplate & '<' & 'cfparam name="attributes.totalrecords" default="0">' & crlf();
            pagerbeforetemplate = pagerbeforetemplate & '<' & 'cfif isDefined("' & stck.name & '_query")><cfset attributes.totalrecords = ' & stck.name & '_query.recordcount></cfif>' & crlf();

            searchdetail = generatefilter( stck.listOfConditions, stck.name );
            //searchdetail = ""; 

            searcharea = generatesearch();

            beforetemplate = "";
            if ( arrayLen(this.data.listLayout.search.layout) ) {
                beforetemplate = beforetemplate & '<c' & 'f_box>';
                beforetemplate = beforetemplate & crlf() & ident( this.identcount + 1 ) & '<c' & 'f_box' & '_elements>';
                beforetemplate = beforetemplate & crlf() & ident( this.identcount + 2 ) & '<c' & 'fform method="POST" name="search_member">';
                beforetemplate = beforetemplate & crlf() & ident( this.identcount + 3 ) & '<i' & 'nput type="hidden" name="searched" value="1">';
                if (arrayLen(this.data.listLayout.search.keyword)) {
                    beforetemplate = beforetemplate & crlf() & ident() & '<d' & 'iv class="row">';
                    beforetemplate = beforetemplate & crlf() & ident() & '<i' & 'nput type="text" name="keyword" id="keyword" value="<cfif isDefined("attributes.keyword")><cfoutput>##attributes.keyword##</cfoutput></cfif>" placeholder="<cf_get_lang dictionary_id=''35258''>"><button type="button" class="keyword-search" onclick="$(''.keyword-after'').toggle()"><i class="fa fa-ellipsis-h"></i></button><cf_wrk_search_button button_type="nocode" is_excel="0">';
                    beforetemplate = beforetemplate & crlf() & ident() & '</div>';
                    beforetemplate = beforetemplate & crlf() & ident() & '<div class="keyword-after" style="display: none">';
                }
                
                beforetemplate = beforetemplate & crlf() & ident( this.identcount + 3 ) & '%s %s';
                
                if (arrayLen(this.data.listLayout.search.keyword) eq 0) {
                    beforetemplate = beforetemplate & crlf() & ident( this.identcount + 3 ) & '<div class="form-group" style="text-align: right;"><div class="col col-12"><cf_wrk_search_button></div></div>';
                }
                if (arrayLen(this.data.listLayout.search.keyword)) {
                    beforetemplate = beforetemplate & crlf() & ident() & '</div>';
                }
                beforetemplate = beforetemplate & crlf() & ident( this.identcount + 2 ) & '</cfform>';
                beforetemplate = beforetemplate & crlf() & ident( this.identcount + 1 ) & '</cf_box_elements>';
                beforetemplate = beforetemplate & crlf() & ident() & '</cf_box>';
                beforetemplate = super.stringFormat( beforetemplate, [ searcharea, searchdetail ] );
            }

            resolver = createObject( "component", "WDO.catalogs.objectResolver" ).init();
            widgetcomponents = resolver.resolveByRequest( namespace:"WDO.catalogs.builders.widgetbuilder.widgetcomponents", hasInit:1 );
            widgetcomponents.addOnload( "pagerbeforetemplate", pagerbeforetemplate );

            headertemplate = crlf() & ident( this.identcount + 3 ) & "<tr>";
            bodytemplate = crlf() & ident( this.identcount + 3 ) & "<tr>";

            languagegenerator = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.languagegenerator");
            dataformatter = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.formatters.dataformatter");
            displayForGenerator = createObject("component", "WDO.catalogs.builders.widgetbuilder.designgenerators.properties.displayfor");
            colcount = 0;
            
            for (lfield in this.data.listLayout.layout)
            {
                lelement = stck.listOfElements[arrayFind(stck.listOfElements, function(elm) {
                    return elm.label eq lfield.label;
                })];
                if ( lelement.fieldType neq "Hidden Input" ) {
                    headertemplate = headertemplate & crlf() & ident( this.identcount + 4 ) & '<cfif 1 eq 1 ' & displayForGenerator.generate( lelement, stck, 'list' ) & '><th>' & languagegenerator.generate( lelement.langNo ) & '</th></cfif>';
                    colcount = colcount + 1;
                }
                fieldTemplate = createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.tableelements.elementfactory" ).create( lelement, stck );
                if ( lelement.fieldType neq "Hidden Input" and lelement.devDBField.value neq "" ) {
                    bodytemplate = bodytemplate & crlf() & ident( this.identcount + 4 ) & '<cfif 1 eq 1 ' & displayForGenerator.generate( lelement, stck, 'list' ) & '><td>' & super.stringFormat( fieldTemplate, ['##' & dataformatter.format( lfield.label, lelement ) & '##'] ) & '</td></cfif>';
                } else if (lelement.fieldType neq "Hidden Input") {
                    bodytemplate = bodytemplate & crlf() & ident( this.identcount + 4 ) & '<cfif 1 eq 1 ' & displayForGenerator.generate( lelement, stck, 'list' ) & '><td>' & super.stringFormat( fieldTemplate, [dataformatter.format( languagegenerator.generate( lelement.langNo ), lelement )] ) & '</td></cfif>';
                }
            }
            bodytemplate = bodytemplate & crlf() & ident( this.identcount + 3 ) & "</tr>";
            headertemplate = headertemplate & crlf() & ident( this.identcount + 3 ) & "</tr>";

            template = ident() & beforetemplate;
            variables.box_block = "";
            boxtemplate = '<c' & 'f_box #build_attr(this.data.listLayout.box, function (v) { variables.box_block = crlf() & ident() & v; })#>';
            template = template & crlf() & ident() & variables.box_block;
            template = template & crlf() & ident() & boxtemplate;
            template = template & crlf() & ident( this.identcount + 1 ) & '<cf_' & 'grid_list>';
            template = template & crlf() & ident( this.identcount + 2 ) & '<t' & 'head>';
            template = template & headertemplate;
            template = template & crlf() & ident( this.identcount + 2 ) & '</thead>';
            template = template & crlf() & ident( this.identcount + 2 ) & '<t' & 'body>';
            template = template & crlf() & ident( this.identcount + 2 ) & '<c' & 'fif isDefined("attributes.searched") and attributes.totalrecords>';
            template = template & crlf() & ident( this.identcount + 2 ) & '<c' & 'foutput query="' & stck.name & '_query" startrow="##attributes.startrow##" maxrows="##attributes.maxrows##">';
            template = template & bodytemplate;
            template = template & crlf() & ident( this.identcount + 2 ) & '</cfoutput>';
            template = template & crlf() & ident( this.identcount + 2 ) & '<c' & 'felseif isDefined("attributes.searched")>';
            template = template & crlf() & ident( this.identcount + 2 ) & '<t' & 'r><td colspan="' & colcount & '">' & languagegenerator.generate( '58486' ) & '</td></tr>';
            template = template & crlf() & ident( this.identcount + 2 ) & '<c' & 'felse>';
            template = template & crlf() & ident( this.identcount + 2 ) & '<t' & 'r><td colspan="' & colcount & '">' & languagegenerator.generate( '57701' ) & '</td></tr>';
            template = template & crlf() & ident( this.identcount + 2 ) & '</cfif>';
            template = template & crlf() & ident( this.identcount + 2 ) & '</tbody>';
            template = template & crlf() & ident( this.identcount + 1 ) & '</cf_grid_list>';
            template = template & crlf() & ident() & '</cf_box>';
            
            pagertemplate = ident() & '<c' & 'f_box>' & crlf();
            pagertemplate = pagertemplate & ident() & '<' & 'table style="width: 100%">' & crlf();
            pagertemplate = pagertemplate & ident() & '<tr><td>' & crlf();
            pagertemplate = pagertemplate & ident() & '<' & 'cfset address = "">' & crlf();
            pagertemplate = pagertemplate & ident() & '<' & 'cfloop array="##structKeyArray(url)##" index="urlelm">' & crlf();
            pagertemplate = pagertemplate & ident( this.identcount + 1 ) & '<' & 'cfif len(url[urlelm]) and urlelm neq "FUSEACTION" and urlelm neq "FIELDNAMES" and urlelm neq "PAGE" and urlelm neq "MAXROWS">' & crlf();
            pagertemplate = pagertemplate & ident( this.identcount + 2 ) & '<' & 'cfset address = address & urlelm & "=" & url[urlelm] & "&">' & crlf();
            pagertemplate = pagertemplate & ident( this.identcount + 1 ) & '<' & 'cfelse>' & crlf();
            pagertemplate = pagertemplate & ident( this.identcount + 2 ) & '<' & 'cfset address = url.FUSEACTION & "&" & address>' & crlf();
            pagertemplate = pagertemplate & ident( this.identcount + 1 ) & '<' & '/cfif>' & crlf();
            pagertemplate = pagertemplate & ident() & '<' & '/cfloop>' & crlf();
            pagertemplate = pagertemplate & ident() & '<' & 'cfloop array="##structKeyArray(form)##" index="formelm">' & crlf();
            pagertemplate = pagertemplate & ident( this.identcount + 1 ) & '<' & 'cfif len(form[formelm]) and formelm neq "FIELDNAMES" and formelm neq "PAGE" and formelm neq "MAXROWS">' & crlf();
            pagertemplate = pagertemplate & ident( this.identcount + 2 ) & '<' & 'cfset address = address & formelm & "=" & form[formelm] & "&">' & crlf();
            pagertemplate = pagertemplate & ident( this.identcount + 1 ) & '<' & '/cfif>' & crlf();
            pagertemplate = pagertemplate & ident() & '<' & '/cfloop>' & crlf();
            pagertemplate = pagertemplate & ident() & '<' & 'cfset address = mid( address, 1, len( address ) -1 )>' & crlf();
            pagertemplate = pagertemplate & ident() & '<cfif attributes.totalrecords><cf_pages page="##attributes.page##" maxrows="##attributes.maxrows##" totalrecords="##attributes.totalrecords##" startrow="##attributes.startrow##" adres="##address##"></cfif></td>' & crlf();
            pagertemplate = pagertemplate & ident() & '<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no="128.Toplam Kayıt">:##attributes.totalrecords##&nbsp;-&nbsp;<cf_get_lang_main no="169.Sayfa">:##attributes.page##/##int(ceiling(attributes.totalrecords/attributes.maxrows))##</cfoutput></td><!-- sil -->' & crlf();
            pagertemplate = pagertemplate & ident() & '</tr></table>' & crlf();
            pagertemplate = pagertemplate & crlf() & ident() & '</cf_box>';

            template = template & crlf() & pagertemplate;
            
        </cfscript>
        <cfreturn template>
    </cffunction>

    <!--- attribute builder --->
    <cffunction name="build_attr">
        <cfargument name="box" type="any">
        <cfargument name="vf">
        
        <cfset languageGenerator = createObject( "component", "WDO.catalogs.builders.widgetbuilder.designgenerators.languagegenerator" )>
        <cfset attrs = arrayNew(1)>
        <cfloop array="#structKeyArray(arguments.box)#" index="key">
            <cfif key eq "title" and len(arguments.box[key])>
                <cfset arguments.vf( '<cfsavecontent variable="getlang_' & key & '">' & languageGenerator.generate(arguments.box[key]) & '</cfsavecontent>' )>
                <cfset arrayAppend( attrs, '#key#="##getlang_' & key & '##"')>
            <cfelseif arguments.box[key] eq "false">
                <cfset arrayAppend( attrs, '#key#="0"', 1 )>
            <cfelseif arguments.box[key] eq "true">
                <cfset arrayAppend( attrs, '#key#="1"', 1 )>
            <cfelseif len( arguments.box[key] )>
                <cfset arrayAppend( attrs, '#key#="#arguments.box[key]#"', 1 )>
            </cfif>
        </cfloop>
        <cfreturn arrayToList( attrs, " " )>
    </cffunction>

</cfcomponent>