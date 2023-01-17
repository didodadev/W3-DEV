<cfparam name="attributes.data_source" default="#caller.DSN#">
<cfparam name="attributes.sort_type" default="#attributes.option_name#">

<cfset queryresult = "caller.#attributes.query_name#">
<cfoutput><label>#attributes.label#</label>
<select class="multiple_select" name="#attributes.name#" id="#attributes.name#" multiple="multiple">
</cfoutput>
    <cfoutput query="#queryresult#">
      <option value="#evaluate(attributes.option_value)#">#evaluate(attributes.option_name)#</option>
  </cfoutput>
</select>
