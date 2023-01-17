<cfset Randomize(round(rand()*1000000))/>
<cfparam name="attributes.id" default="wuxi_#round(rand()*10000000)#">
<cfparam name="attributes.type" default="text">
<!--- element tipi "text, img, cell" --->
<cfparam name="attributes.class" default="">
<cfparam name="attributes.style_th" default="">
<cfparam name="attributes.style" default="">
<cfparam name="attributes.style_pbar" default="">
<cfparam name="attributes.label" default="">
<cfparam name="attributes.is_row" default=1>
<cfparam name="attributes.data" default="">
<cfparam name="attributes.data_type" default="text">
<!--- şifrelerken görünsün fakat herhangi bir işlem yapmaması için 0 gönderilir. --->
<cfparam name="attributes.hide" default="1">
<cfparam name="attributes.is_empty" default="">
<cfparam name="attributes.output" default="true">
<cfparam name="attributes.list" default="">
<cfparam name="attributes.row" default="">
<cfparam name="attributes.schema_type" default="">
<!--- gdpr “1,2,3,4,5,6” --->
<cfparam name="attributes.gdpr" default="">
<cfset label_value = "">
<cfif len(attributes.label)>
    <cfloop list="#attributes.label#" delimiters="+" index="i" item="c">
        <cfsavecontent variable="tmplabel">
            <cf_get_lang dictionary_id="#c#">
        </cfsavecontent>
        <cfset label_value = listAppend(label_value, tmplabel, " ")>
    </cfloop>
</cfif>
<cfset data_value = "">
<cfif len(attributes.data)>
    <cfif attributes.data_type eq 'dictionary'>
        <cfloop list="#attributes.data#" delimiters="+" index="i" item="c">
            <cfsavecontent variable="dict_data">
                <cf_get_lang dictionary_id="#c#">
            </cfsavecontent>
            <cfset data_value = listAppend(data_value, dict_data, " ")>
        </cfloop>
    <cfelse>
        <cfset data_value = attributes.data>
    </cfif>
</cfif>
<cfset getPrintTemplate = createObject("component","cfc.get_print_template")>
<cfset get_templates_css = getPrintTemplate.get_template( template_id : caller.attributes.template_id )>
<cfset SCHEMA_TYPE = '#get_templates_css.SCHEMA_MARKUP#'>
<cfif len(attributes.list)>
	<cfif not isDefined("#CALLER.SCHEMA_ORG.SCHEMA_TYPE#.#attributes.list#")>
		<cfset "#CALLER.SCHEMA_ORG.SCHEMA_TYPE#.#attributes.list#"= []>
		<cfset content = (len(attributes.schema_type))?{}:attributes.data>
		<cfscript>
			ArraySet(Evaluate("#CALLER.SCHEMA_ORG.SCHEMA_TYPE#.#attributes.list#"), attributes.row,attributes.row, content)
		</cfscript>
	<cfelse>
		<cfset list_ = evaluate("#CALLER.SCHEMA_ORG.SCHEMA_TYPE#.#attributes.list#")>
		<cfif arrayLen(list_) neq attributes.row>
			<cfset content = (len(attributes.schema_type))?{}:attributes.data>
			<cfscript>
				ArraySet(Evaluate("#CALLER.SCHEMA_ORG.SCHEMA_TYPE#.#attributes.list#"), attributes.row,attributes.row, content)
			</cfscript>
		</cfif>	
	</cfif>	
</cfif>

<cfif isdefined('CALLER.SCHEMA_ORG') and StructKeyExists(evaluate("CALLER.SCHEMA_ORG"), SCHEMA_TYPE) EQ 'NO'>
    <cfset "#CALLER.SCHEMA_ORG.SCHEMA_TYPE#" = {}>
</cfif>

<cfif isdefined('CALLER.SCHEMA_ORG') and StructKeyExists(evaluate("#CALLER.SCHEMA_ORG.SCHEMA_TYPE#"), "type") EQ 'NO'>
    <cfset main_type = { '@type' : SCHEMA_TYPE, '@context': 'https://schema.org/'}>
	<cfscript>
		StructAppend(evaluate("#CALLER.SCHEMA_ORG.SCHEMA_TYPE#"),main_type,true);
	</cfscript>
</cfif>


<cfif len(attributes.schema_type) AND len(attributes.data) AND len(SCHEMA_TYPE)>
    <cfif len(attributes.list)>			
		<cfset row = Evaluate("#CALLER.SCHEMA_ORG.SCHEMA_TYPE#.#attributes.list#")[attributes.row]>
		<cfif Find("@",attributes.schema_type)>
			<cfset x = "{">
			<cfset y = 1>
			<cfloop array="#listToArray(attributes.schema_type,".")#" item="item">	
				<cfset x &= '"#item#":' & (y neq arrayLen(listToArray(attributes.schema_type,"."))? '{': '"#attributes.data#"')>
				<cfset y += 1>
			</cfloop>
			<cfloop array="#listToArray(attributes.schema_type,".")#" item="item">	
				<cfset x &= "}">
			</cfloop>
			<cfset rowx = deserializeJSON(x)>
			<cfscript>
				StructAppend(row,rowx,true);
				ArraySet(Evaluate("#CALLER.SCHEMA_ORG.SCHEMA_TYPE#.#attributes.list#"), attributes.row,attributes.row, row)
			</cfscript>
		<cfelse>
			<cfset "row.#attributes.schema_type#" = attributes.data>
		</cfif>	
		
		
	<cfelse>
		<cfif Find("@",attributes.schema_type)>
			<cfset x = "{">
			<cfset y = 1>
			<cfloop array="#listToArray(attributes.schema_type,".")#" item="item">	
				<cfset x &= '"#item#":' & (y neq arrayLen(listToArray(attributes.schema_type,"."))? '{': '"#attributes.data#"')>
				<cfset y += 1>
			</cfloop>
			<cfloop array="#listToArray(attributes.schema_type,".")#" item="item">	
				<cfset x &= "}">
			</cfloop>
			<cfscript>
				StructAppend(evaluate("#CALLER.SCHEMA_ORG.SCHEMA_TYPE#"),deserializeJSON(x),true);
			</cfscript>
		<cfelse>
			<cfset "#CALLER.SCHEMA_ORG.SCHEMA_TYPE#.#attributes.schema_type#" = attributes.data>
		</cfif>	 
    </cfif>
		
</cfif>

<cfif len(attributes.gdpr)>
    <cfobject name="gdpr_" type="component" component="workdata.get_gdpr_control">
    <cfset caller.__control_gdpr = gdpr_.getComponentFunction()>
    <cfset control_gdpr = caller.__control_gdpr>
    <cfset data_value_ = '#data_value#'>
    <cfset caller.__get_gdpr = gdpr_.getComponentFunctionGDPR(gdpr_ : attributes.gdpr)>
    <cfset get_gdpr = caller.__get_gdpr>
    <cfif not get_gdpr.recordcount>
        <cfif attributes.hide eq 1>
            <cfset data_value = "*******#mid(data_value_,1,2)#">
        </cfif>
    </cfif>
</cfif>

<cfsavecontent variable="generated_content">
    <cfoutput>
        <cfswitch expression="#attributes.type#">
            <cfcase value="text">
                <label>#data_value#</label>
            </cfcase>
            <cfcase value="img">
                <img src="#data_value#" class="#(len(attributes.class)?attributes.class:'')#" style="#(len(attributes.style)?attributes.style:'')#">
            </cfcase>
            <cfcase value="cell">
                <td class="#(len(attributes.class)?attributes.class:'')#" style="#(len(attributes.style)?attributes.style:'')#">#data_value#</td>
            </cfcase>
            <cfcase value="progress">
                <td>	
                    <div class="progress ml-0" style="#(len(attributes.style)?attributes.style:'')#">
                        <div class="progress-bar bg-color-1" style="#(len(attributes.style_pbar)?attributes.style_pbar:'')# width:<cfoutput>#data_value#</cfoutput>%" role="progressbar" aria-valuenow="#data_value#" aria-valuemin="0" aria-valuemax="100">
                        </div>
                    </div>
                </td>
            </cfcase>
        </cfswitch>
    </cfoutput>
</cfsavecontent>
<cfoutput>
    <cfif attributes.output eq true>
        <cfif attributes.is_row eq 1>
            <tr <cfif len(attributes.class)>class="#attributes.class#"</cfif> <cfif len(attributes.style)>style="#attributes.style#"</cfif> id="#attributes.id#">
                <cfif len(label_value)><td class="bold" <cfif isdefined("attributes.border") and len(attributes.border)>style="#attributes.border#"</cfif>>#label_value#</td></cfif>
                <cfif len(attributes.data)>#generated_content#</cfif>
            </tr>
            <cfif caller.attributes.fuseaction eq 'objects.popup_print_designer'>
                <script type="text/javascript">
                    $( "###attributes.id#" ).draggable();
                </script>
            </cfif>
        <cfelse>
            <cfif len(label_value)><th data-resizable-column-id="#attributes.id#" id="#attributes.id#" style="#(len(attributes.style_th)?attributes.style_th:'')#">#label_value#</th></cfif>
            <cfif len(attributes.data)>#generated_content#<cfelseif len(attributes.style_th)><td></td></cfif>
        </cfif>
    </cfif>
</cfoutput>
<cfif caller.attributes.fuseaction eq 'objects.popup_print_files'>
    <script>
        $("td").each(function (index) {
            $(this).attr("id", "col"+index);
        });
        $(function() {
            <cfif len(get_templates_css.data_design)>   
                var design = JSON.parse(<cfoutput>#get_templates_css.data_design#</cfoutput>);
                for(var i = 0; i < design.length; i++) {
                    $('#' + design[i].key).attr('style',design[i].value);
                    }
            </cfif>
        })
    </script>
</cfif>