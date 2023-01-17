<!--- Çoklu select yapısı py --->
<script type="text/javascript">
	myset_all = '<cf_get_lang_main no="296.Tümü">';
</script>
<cfif not caller.fusebox.fuseaction contains 'autoexcelpopuppage_'>
    <cfparam name="attributes.separated" default="1">
    <cfparam name="attributes.is_load" default="0">
    <cfif not isdefined("caller.ismultiselect_used")>
        <link rel="stylesheet" type="text/css" href="../css/temp/multiselect_check/jquery.multiselect.css">
        <cfif isdefined("attributes.is_load") and attributes.is_load eq 0>
            <!---<script type="text/javascript" src="../JS/jquery-1_7_1_min.js"></script>--->
            <!---<script type="text/javascript" src="../JS/jquery-ui-1.8.14.custom.min.js"></script>--->
            <script type="text/javascript" src="../JS/temp/multiselect/jquery.multiselect.filter.js"></script>
            <cfif isdefined("attributes.separated") and attributes.separated eq 2>
                <script type="text/javascript" src="../JS/temp/multiselect/xjquery.multiselect.js"></script>
            <cfelse>
                <script type="text/javascript" src="../JS/temp/multiselect/jquery.multiselect.js"></script>
            </cfif>
        </cfif>
        <cfset caller.ismultiselect_used=1><!--- çağıran sayfa için bir değişken tanımladık--->
    </cfif>
    <cfparam name="attributes.width" default="150">
	<cfparam name="attributes.menuWidth" default="">
    <cfparam name="attributes.all_select" default="0">
    <cfparam name="attributes.form_submit" default="0">
    <cfparam name="attributes.name" default="">
    <cfparam name="attributes.value" default="">
    <cfparam name="attributes.option_value" default="">
    <cfparam name="attributes.option_name" default="">
    <cfparam name="attributes.data_source" default="#caller.DSN#">
    <cfparam name="attributes.table_name" default="">
    <cfparam name="attributes.query_name" default="">
    <cfparam name="attributes.group_query_name" default="">
    <cfparam name="attributes.group_option_name" default="">
    <cfparam name="attributes.disabled" default="0">
    <cfparam name="attributes.autoopen" default="0">
    <cfparam name="attributes.height" default="150">
    <cfparam name="attributes.onchange" default="">
    <cfparam name="attributes.is_option_text" default="1">
    <cfparam name="attributes.filter" default="1">
    <cfparam name="attributes.single_select" default="0">
    <cfparam name="attributes.tabindex" default="">
    <cfparam name="attributes.sort_type" default="#attributes.option_name#">
    <cfparam name="attributes.option_text" default="#caller.getLang('main',322)#"><!--- Seçiniz --->
    
    <cfif isdefined("attributes.table_name") and len(attributes.table_name)>
        <cfinvoke 
                component = "/workdata/get_query" 
                method="getComponentFunction" 
                returnvariable="queryResult">
                <cfinvokeargument name="data_source" value="#attributes.data_source#">
                <cfinvokeargument name="table_name" value="#attributes.table_name#">
                <cfinvokeargument name="option_name" value="#attributes.option_name#">
                <cfinvokeargument name="option_value" value="#attributes.option_value#">
                <cfinvokeargument name="sort_type" value="#attributes.sort_type#">
            </cfinvoke>
            <select class="multiSelect" id="<cfoutput>#attributes.name#</cfoutput>" name="<cfoutput>#attributes.name#</cfoutput>" multiple="multiple" style="width:<cfoutput>#attributes.width#</cfoutput>px;" <cfif len(attributes.tabindex)>tabindex="<cfoutput>#attributes.tabindex#</cfoutput>"</cfif>>
                <cfoutput query="queryResult">
                  <option value="#evaluate(attributes.option_value)#" <cfif len(attributes.value) and listfind(attributes.value,evaluate(attributes.option_value),',')>selected</cfif>>#evaluate(attributes.option_name)#</option>  
                </cfoutput>
            </select>
    <cfelseif len(attributes.query_name)>
        <cfset queryresult = "caller.#attributes.query_name#">
        <select class="multiSelect" id="<cfoutput>#attributes.name#</cfoutput>" name="<cfoutput>#attributes.name#</cfoutput>" multiple="multiple" style="width:<cfoutput>#attributes.width#</cfoutput>px;" <cfif len(attributes.tabindex)>tabindex="<cfoutput>#attributes.tabindex#</cfoutput>"</cfif>>
            <cfoutput query="#queryResult#">
                <cfif attributes.option_value contains '-'>
                    <cfset option_multi_value = ''>
                    <cfset eleman_sayisi = listLen(attributes.option_value,'-')>
                    <cfloop index="aa" from="1" to="#eleman_sayisi#">
                        <cfset option_multi_value_text = listGetAt(attributes.option_value,aa,'-')>
                        <cfset option_multi_value_text = evaluate(option_multi_value_text)>
                        <cfif option_multi_value is ''>
                            <cfset option_multi_value = option_multi_value_text>
                        <cfelse>
                            <cfset option_multi_value = option_multi_value & '-' & option_multi_value_text>
                        </cfif>
                    </cfloop>
                   <option value="#option_multi_value#" <cfif len(attributes.value) and listfind(attributes.value,option_multi_value,',')>selected</cfif>>#evaluate(attributes.option_name)#</option>  
                <cfelseif attributes.option_name contains '-'>
                    <cfset option_multi_name = ''>
                    <cfset eleman_sayisi = listLen(attributes.option_name,'-')>
                    <cfloop index="aa" from="1" to="#eleman_sayisi#">
                        <cfset option_multi_name_text = listGetAt(attributes.option_name,aa,'-')>
                        <cfset option_multi_name_text = evaluate(option_multi_name_text)>
                        <cfif option_multi_name is ''>
                            <cfset option_multi_name = option_multi_name_text>
                        <cfelse>
                            <cfset option_multi_name = option_multi_name & '-' & option_multi_name_text>
                        </cfif>
                    </cfloop>
                   <option value="#evaluate(attributes.option_value)#" <cfif len(attributes.value) and listfind(attributes.value,evaluate(attributes.option_value),',')>selected</cfif>>#option_multi_name#</option>  
                <cfelse>
                    <option value="#evaluate(attributes.option_value)#" <cfif len(attributes.value) and listfind(attributes.value,evaluate(attributes.option_value),',')>selected</cfif>>#evaluate(attributes.option_name)#</option>  
                </cfif>
            </cfoutput>
        </select>
    </cfif>
    
    <script>
    try{
        <cfif attributes.all_select eq 1 and attributes.form_submit neq 1>
            $("#<cfoutput>#attributes.name#</cfoutput> option").prop("selected",true).trigger("change");
        </cfif>
    $("#<cfoutput>#attributes.name#</cfoutput>")
       .multiselect({
          minWidth:<cfoutput>#attributes.width#</cfoutput>,
          height:<cfoutput>#attributes.height#</cfoutput>,
		  <cfif len(attributes.menuWidth)>
			menuWidth:<cfoutput>#attributes.menuWidth#</cfoutput>,
		  </cfif>
          //show:['slide', 500],  
          checkAllText:"<cf_get_lang_main no='1281.Sec'>",
          uncheckAllText:"<cf_get_lang_main no='1898.Kaldir'>",
          <cfif attributes.is_option_text eq 1>
            noneSelectedText: '<cfoutput>#attributes.option_text#</cfoutput>',
          <cfelse>
            noneSelectedText: '',
          </cfif>
          <cfif attributes.autoopen eq 1>
            autoOpen: true,
          </cfif>
          selectedText: '# / #<cf_get_lang_main no="2011.Kayıt Secildi">'
          
       });
      
      
    <cfif attributes.filter eq 1>
        //$("#<cfoutput>#attributes.name#</cfoutput>").multiselect().multiselectfilter();
        $("#<cfoutput>#attributes.name#</cfoutput>").multiselect({
        open: function () {
            $("input[type='search']").focus();                   
        }
    });
    </cfif>
        //.bind('multiselectclick',goster);  check ya da uncheck de fonksiyon çalıştırıyor
    <cfif len(attributes.onchange)>
    
	var ms_onchange_function_<cfoutput>#attributes.name#</cfoutput> = function()
        {
            <cfoutput>#attributes.onchange#</cfoutput>;
            return true;
        }
        
    <!---	$("#<cfoutput>#attributes.name#</cfoutput>").bind("change", ms_onchange_function_<cfoutput>#attributes.name#</cfoutput>);
    --->
        $("#<cfoutput>#attributes.name#</cfoutput>").multiselect().bind('multiselectclick multiselectcheckall multiselectuncheckall',ms_onchange_function_<cfoutput>#attributes.name#</cfoutput>);
 //           html.push(' checked="checked"');
 //           html.push(' aria-selected="true"');
    </cfif>
    
     
    <cfif attributes.disabled eq 1>
    var $widget = $("#<cfoutput>#attributes.name#</cfoutput>").multiselect(),  
    state = true;
        $("#toggle-disabled").click(function(){ 
           state = !state; 
           $widget.multiselect(state ? 'disable' : 'enable'); 
        });
    </cfif>
    }catch(err){/*console.log(err)*/};
    </script>
</cfif>
