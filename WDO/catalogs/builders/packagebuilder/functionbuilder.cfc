<cfcomponent>

    <cfproperty name="beforebody" default="">

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset _crlf = "">


    <cffunction name="generate" access="public">
        <cfargument name="fuseaction">
        <cfargument name="event">
        <cfargument name="struct_name">

        <cfquery name="jsonForFuseAction" datasource="#dsn#" >         
            SELECT MODEL_FUSEACTION, MODELJSON
            FROM WRK_MODEL
            WHERE MODEL_FUSEACTION = <cfqueryparam value="#arguments.fuseaction#" CFSQLType="CF_SQL_NVARCHAR">
        </cfquery>
        <!---
        <cfquery name="jsonWidgetFuseaction" datasource="#dsn#">
            SELECT 
        </cfquery>
        --->
        <cfset modelStructName =deSerializeJson( jsonForFuseAction.MODELJSON )>

        <cftry>
        <cfscript>  
            
            this.beforebody = "";

            result = '';

            findModelStructName = ArrayFilter( modelStructName, function( item ) {
                return item.name eq struct_name;
            });
            findModelStructName = findModelStructName[1];
            if ( findModelStructName.structType eq "main" ) {
                result = result & generate_main( arguments.fuseaction, arguments.event, findModelStructName );
            } else {
                result = result & generate_sub( arguments.fuseaction, arguments.event, findModelStructName );
            }
            if (len(this.beforebody)) result = this.beforebody & crlf() & result;
        </cfscript>
        <cfcatch>
            <cfdump var="#cfcatch#" abort>
        </cfcatch>
    </cftry>
        <cfreturn result>
    </cffunction>

    <cffunction name="generate_main" access="private">
        <cfargument name="fuseaction">
        <cfargument name="event">
        <cfargument name="model">
        
        <cfscript>
            precode = "";
            code = '<c' & 'fscript>' & crlf();
            code = code & arguments.model.name & "_ref = " & underscore_fuseaction( arguments.fuseaction ) & '_component.';
            
            structName =  arguments.model.name;
            code = code & structName & "_" & arguments.event & '(';
            elementList = arguments.model.listOfElements;

            propertiesArray = arrayNew(1);
            
            for ( i=1; i <= arrayLen( arguments.model.listOfElements ); i++) {

                if ( arguments.event eq 'add' and elementList[i].devAdd eq 1 and elementList[i].includeAdd eq 1 ) {
                    switch (elementList[i].fieldType) {
                        case "workflow":
                            ArrayAppend( propertiesArray, 'attributes.process_stage' & (elementList[i].isRequired eq "1" ? '' : '?:""') );
                            precode = precode & "<c" & 'f_workcube_process is_upd="1" is_detail="##(attributes.event eq "add")?0:1##" process_stage="##attributes.process_stage##" record_date="##now()##" old_process_line="##isDefined("attributes.old_process_line")?attributes.old_process_line:0##">';
                            break;
                        case "process cat":
                            ArrayAppend( propertiesArray, 'attributes.process_cat' & (elementList[i].isRequired eq "1" ? '' : '?:""') );
                            break;
                        default:
                            ArrayAppend( propertiesArray, 'attributes.' & elementList[i].label & (elementList[i].isRequired eq "1" ? '' : '?:""') ) ;
                    }
                } else if ( arguments.event eq 'update' and elementList[i].devUpdate eq 1 and elementList[i].includeUpdate eq 1 ) {
                    
                    switch (elementList[i].fieldType) {
                        case "workflow":
                            ArrayAppend( propertiesArray, 'attributes.process_stage' & (elementList[i].isRequired eq "1" ? '' : '?:""') );
                            precode = precode & "<c" & 'f_workcube_process is_upd="1" is_detail="##(attributes.event eq "add")?0:1##" process_stage="##attributes.process_stage##" record_date="##now()##" old_process_line="##isDefined("attributes.old_process_line")?attributes.old_process_line:0##">';
                            break;
                        case "process cat":
                            ArrayAppend( propertiesArray, 'attributes.process_cat' & (elementList[i].isRequired eq "1" ? '' : '?:""') );
                            break;
                        default:
                            ArrayAppend( propertiesArray, 'attributes.' & elementList[i].label & (elementList[i].isRequired eq "1" ? '' : '?:""') ) ;
                    }
                }

                if (elementList[i].dataType eq "date") {
                    if (elementList[i].filterAsRange eq "1") {
                        precode = precode & '<c' & 'fif isDefined("attributes.' & elementList[i].label & '_min")><cf_date tarih="attributes.' & elementList[i].label & '_min"></cfif>';
                        precode = precode & '<c' & 'fif isDefined("attributes.' & elementList[i].label & '_max")><cf_date tarih="attributes.' & elementList[i].label & '_max"></cfif>';
                    } else {
                        precode = precode & '<c' & 'fif isDefined("attributes.' & elementList[i].label & '")><cf_date tarih="attributes.' & elementList[i].label & '"></cfif>';
                    }
                }

            }
            code = code & ArrayToList( propertiesArray,', ' ) & ');' & crlf();
            code = code & '</cfscript>' & crlf();

            if (event eq "add" or event eq "update") {
                solrbuilder = createObject("component", "WDO.catalogs.builders.packagebuilder.extensions.solrbuilder");
                code = code & solrbuilder.generate_data( arguments.fuseaction, arguments.event, arguments.model ) & crlf();
            }
            this.beforebody = this.beforebody & crlf() & precode;
        </cfscript>
        <cfreturn code>
    </cffunction>

    <cffunction name="generate_sub" access="private">
        <cfargument name="fuseaction">
        <cfargument name="event">
        <cfargument name="model">

        <cfscript>
            elementList = arguments.model.listOfElements;

            firstElms = arrayFilter( elementList, function( elm ) {
                return ( event eq 'add' and elm.devAdd eq 1 ) 
                    or ( event eq 'update' and elm.devUpdate eq 1 ); 
            });
            if ( arrayLen( firstElms ) ) {
                firstElm = firstElms[1];
                if (firstElm.isKey) {
                    firstElm = firstElms[2];
                }
            } else {
                return "";
            }

            structName =  arguments.model.name;
            elementList = arguments.model.listOfElements;

            propertiesArray = arrayNew(1);
            fieldcontrol = "";
            relationName = replace( arguments.model.relation, ".", "" );

            for ( i=1; i <= arrayLen( arguments.model.listOfElements ); i++) {

                if ( ( ( arguments.event eq 'add' and elementList[i].devAdd eq 1 ) or ( arguments.event eq 'update' and elementList[i].devUpdate eq 1 and elementList[i].isKey eq false ) and ( elementList[i].fieldType neq "Text" ) ) ) {
                    if ( elementList[i].label eq relationName ) {
                        ArrayAppend( propertiesArray,  elementList[i].label & ':' & listFirst( arguments.model.relation, '.' ) & "_ref" ) ;
                    } else {
                        ArrayAppend( propertiesArray, elementList[i].label & ':' & 'attributes["' & elementList[i].label & '" & i]' ) ;
                        if ( not len( fieldcontrol ) )
                            fieldcontrol = 'structKeyExists( attributes, "' & firstElm.label & '" & i )';
                    }
                } 
                /*
                else if ( arguments.event eq 'update' and elementList[i].devUpdate eq 1 ) {
                    ArrayAppend( propertiesArray, 'attributes["' & elementList[i].label & '" & i]' ) ;
                }
                */

            }
            code = '<c' & 'fscript>' & crlf();
            code = code & Replace( arguments.fuseaction, ".", "_" ) & '_component.';
            code = code & arguments.model.name & '_';
            code = code & 'delete( ' & listfirst( arguments.model.relation, "." ) & "_ref );" & crlf();

            code = code & 'maxindex = arrayReduce( arrayFilter( structKeyArray( attributes ), function( elm ) {' & crlf();
            code = code & '    return mid( elm, 1, ' & len( firstElm.label ) & ' ) eq "' & firstElm.label & '";' & crlf();
            code = code & '}), function( v, e ) {'  & crlf();
            code = code & '    if ( not isDefined("v") ) v = 0;' & crlf();
            code = code & '    return max( v, val( mid( e, ' & ( len( firstElm.label ) + 1 ) & ', ' & len( firstElm.label ) & ' ) ) );' & crlf();
            code = code & '});' & crlf();
            code = code & 'for ( i = 0; i <= maxindex; i++ ) {' & crlf();
            /*
            if ( len( relationName ) ) {
                code = code & relationName & ' = iif( attributes["' & relationName & '" & i] eq "" or attributes["' & relationName & '" & i] eq 0, de( phonebook_ref ), de( attributes["' & relationName & '" & i] ) );' & crlf();
            }
            */
            if ( len( fieldcontrol ) ) {
                code = code & 'if ( not ' & fieldcontrol & ' ) continue;' & crlf();
            }
            code = code & Replace( arguments.fuseaction, ".", "_" ) & '_component.';
            
            code = code & arguments.model.name & '_';
            code = code & 'add( ';
            code = code & ArrayToList( propertiesArray,', ' ) & ' );' & crlf();
            code = code & '}' & crlf();
            code = code & '</cfscript>' & crlf();
        </cfscript>

        <cfreturn code>
    </cffunction>

    <!--- helpers --->
    <cffunction name="underscore_fuseaction">
        <cfargument name="fuseaction" type="string">
        <cfreturn replace( arguments.fuseaction, ".", "_" )>
    </cffunction>

    <cffunction name="crlf" access="public" returntype="string">
        <cfscript>
            if (len(_crlf) eq 0)
            {
                _crlf = CreateObject("java", "java.lang.System").getProperty("line.separator");
            }
        </cfscript>
        <cfreturn _crlf>
    </cffunction>

</cfcomponent>