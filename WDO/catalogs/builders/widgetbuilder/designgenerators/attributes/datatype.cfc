<cfcomponent extends="WDO.catalogs.builders.widgetbuilder.designgenerators.attributes.attribute">
    
    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="precodeCallback" type="any">
        <cfargument name="postcodeCallback" type="any">
        <cfscript>
            result = "";
            switch ( this.element.dataType )
            {
                case "Numeric":
                    result = 'data-rule-digits="true"';
                    break;
                case "Date":
                    precodeCallback('<div class="input-group">');
                    result = 'data-rule-wcdate="<cfoutput>##dateFormat_style##</cfoutput>"';
                    postcodeCallback('<span class="input-group-addon">');
                    postcodeCallback('<cf_wrk_date_image date_field="#this.structname#_#this.element.label#">');
                    postcodeCallback('</span>');
                    postcodeCallback('</div>');
                    break;
                case "Money":
                    result = 'data-rule-number="true" onkeyup="return(FormatCurrency(this,event,##session.ep.our_company_info.rate_round_num##));"';
                    break;
                case "E-Mail":
                    result = '';
                    break;
                case "Phone":
                    result = 'data-rule-digits="true" minlength="10"';
                    break;
                default:
                result = '';
            }
            if ( this.element.minSize neq "" )
            {
                result = result & ' minlength="' & this.element.minSize & '"';
            }
            if ( this.element.maxSize neq "" )
            {
                result = result & ' maxlength="' & this.element.maxSize & '"';
            }
            if ( this.element.minSize neq "" or this.element.maxSize neq "" ) 
            {
                result = result = ' pattern=".{' & ( len(this.element.minSize) ? this.element.minSize : '0' ) & ',' & ( len(this.element.maxSize) ? this.element.maxSize : '' ) & '}"';
            }
            if ( isDefined("this.element.floatsize") and this.element.floatsize neq "" )
            {
                result = result = ' data-floatsize="' & this.element.floatsize & '" onblur="this.value=(parseFloat(Math.round(parseFloat(this.value.replace('','', ''.'')) + ''e+'& this.element.floatsize &''')+''e-'& this.element.floatsize &''')).toString().replace(''.'', '','')"';
            }
            if ( this.element.isrequired eq 1 )
            {
                result = result & ' required';
            }
            
        </cfscript>
        <cfreturn result>
    </cffunction>

</cfcomponent>