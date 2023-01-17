<cfif not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset cookie_name_ = createUUID()>
	<cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#cookie_name_#" expires="1">
</cfif>
<cfparam name="attributes.type_id" default="-7">
<cfquery name="GET_VALUES" datasource="#DSN3#">
	SELECT
		PROPERTY1
	FROM
		ORDER_INFO_PLUS
	WHERE
		RECORD_GUEST = 1 AND 
		RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
		COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
</cfquery>
<cfquery name="GET_LABELS" datasource="#DSN3#">
	SELECT
		PROPERTY1_NAME,
		PROPERTY1_REQ,
        PROPERTY1_TYPE,
        PROPERTY1_MESSAGE,
        PROPERTY1_RANGE,
		PROPERTY2_NAME,
		PROPERTY2_REQ,
        PROPERTY2_TYPE,
        PROPERTY2_MESSAGE,
        PROPERTY2_RANGE,
		PROPERTY3_NAME,
		PROPERTY3_REQ,
        PROPERTY3_TYPE,
        PROPERTY3_MESSAGE,
        PROPERTY3_RANGE,
		PROPERTY4_NAME,
		PROPERTY4_REQ,
        PROPERTY4_TYPE,
        PROPERTY4_MESSAGE,
        PROPERTY4_RANGE,
		PROPERTY5_NAME,
		PROPERTY5_REQ,
        PROPERTY5_TYPE,
        PROPERTY5_MESSAGE,
        PROPERTY5_RANGE,
		PROPERTY6_NAME,
		PROPERTY6_REQ,
        PROPERTY6_TYPE,
        PROPERTY6_MESSAGE,
        PROPERTY6_RANGE,
		PROPERTY7_NAME,
		PROPERTY7_REQ,
        PROPERTY7_TYPE,
        PROPERTY7_MESSAGE,
        PROPERTY7_RANGE,
		PROPERTY8_NAME,
		PROPERTY8_REQ,
        PROPERTY8_TYPE,
        PROPERTY8_MESSAGE,
        PROPERTY8_RANGE,
		PROPERTY9_NAME,
		PROPERTY9_REQ,
        PROPERTY9_TYPE,
        PROPERTY9_MESSAGE,
        PROPERTY9_RANGE,
		PROPERTY10_NAME,
		PROPERTY10_REQ,
        PROPERTY10_TYPE,
        PROPERTY10_MESSAGE,
        PROPERTY10_RANGE,
		PROPERTY11_NAME,
		PROPERTY11_REQ,
        PROPERTY11_TYPE,
        PROPERTY11_MESSAGE,
        PROPERTY11_RANGE,
		PROPERTY12_NAME,
		PROPERTY12_REQ,
        PROPERTY12_TYPE,
        PROPERTY12_MESSAGE,
        PROPERTY12_RANGE,
		PROPERTY13_NAME,
		PROPERTY13_REQ,
        PROPERTY13_TYPE,
        PROPERTY13_MESSAGE,
        PROPERTY13_RANGE,
		PROPERTY14_NAME,
		PROPERTY14_REQ,
        PROPERTY14_TYPE,
        PROPERTY14_MESSAGE,
        PROPERTY14_RANGE,
		PROPERTY15_NAME,
		PROPERTY15_REQ,
        PROPERTY15_TYPE,
        PROPERTY15_MESSAGE,
        PROPERTY15_RANGE,
		PROPERTY16_NAME,
		PROPERTY16_REQ,
        PROPERTY16_TYPE,
        PROPERTY16_MESSAGE,
        PROPERTY16_RANGE,
		PROPERTY17_NAME,
		PROPERTY17_REQ,
        PROPERTY17_TYPE,
        PROPERTY17_MESSAGE,
        PROPERTY17_RANGE,
		PROPERTY18_NAME,
		PROPERTY18_REQ,
        PROPERTY18_TYPE,
        PROPERTY18_MESSAGE,
        PROPERTY18_RANGE,
		PROPERTY19_NAME,
		PROPERTY19_REQ,
        PROPERTY19_TYPE,
        PROPERTY19_MESSAGE,
        PROPERTY19_RANGE,
		PROPERTY20_NAME,
		PROPERTY20_REQ,
        PROPERTY20_TYPE,
        PROPERTY20_MESSAGE,
        PROPERTY20_RANGE
	FROM
		SETUP_PRO_INFO_PLUS_NAMES
	WHERE	
		OWNER_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
</cfquery>
<cfif get_labels.recordcount>
    <table id="info_table" <cfif GET_VALUES.recordcount and attributes.is_hidden_info eq 1>style="display:none;"</cfif>>
    	<tr>
    		<td style="vertical-align:top;">
    			<cfif get_values.recordcount>
    				<cfset send_par="upd_info_plus_act">
    			<cfelse>
    				<cfset send_par="add_info_plus_act">
    			</cfif>
    			<cfform action="#request.self#?fuseaction=objects2.#send_par#" method="post" name="send_form">
    				<table>
    					<input type="hidden" name="cookie_name" id="cookie_name" value="<cfoutput>#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#</cfoutput>">
    					<cfloop index="i" from="1" to="7">
                            <tr>
                                <td style="width:100px;">
									<cfif len(Evaluate("get_labels.property#i#_name"))>
                                    	<cfoutput>#Evaluate("get_labels.property#i#_name")#</cfoutput>
                                    	<cfif Evaluate("get_labels.property#i#_req") eq 1>*</cfif>
                                    </cfif>
                                </td>
                                <td>
									<cfif len(Evaluate("get_labels.property#i#_name"))>
                                    	<cfif get_values.recordcount>
                                    		<cfset value_ = "#Evaluate('get_values.property#i#')#">
                                    	<cfelse>
                                    		<cfset value_ = "">
                                    	</cfif>
                                    	<cfif len(Evaluate('get_labels.property#i#_type'))>
                                    		<cfset validate_ = "#Evaluate('get_labels.property#i#_type')#">
                                    	<cfelse>
                                    		<cfset validate_ = "">
                                    	</cfif>
                                    	<cfif len(Evaluate('get_labels.property#i#_message'))>
                                    		<cfset message_ = "#Evaluate('get_labels.property#i#_message')#">
                                    	<cfelse>
                                    		<cfset message_ = "">
                                    	</cfif>
                                    	<cfif len(Evaluate('get_labels.property#i#_range'))>
                                    		<cfset max_ = "#Evaluate('get_labels.property#i#_range')#">
                                    	<cfelse>
											<cfset max_ = "50">
                                    	</cfif>
                                    <cfif isdefined("attributes.is_char_control") and attributes.is_char_control eq 1>
                                    <!---			<cfinput type="text" name="PROPERTY#i#" value="#value_#" style="width:250px;" validate="#validate_#" message="#message_#" maxlength="#max_#" onBlur="return(char_control_all(this));">
                                    --->	
                                    <cfelse>
                                    	<cfinput type="text" name="property#i#" id="property#i#" value="#value_#" style="width:250px;" validate="#validate_#" message="#message_#" maxlength="#max_#">
                                    </cfif>
                                </cfif>
                            </td>
                            <td>
                                <cfset j=i+7>
                                <cfif len(Evaluate("get_labels.property#j#_name"))>
                                    <cfoutput>#Evaluate("get_labels.property#j#_name")#</cfoutput>
                                    <cfif Evaluate("get_labels.property#j#_req") eq 1>*</cfif>
                                </cfif>
                            </td>
                            <td>
                                <cfif len(Evaluate("get_labels.property#j#_name"))>
                                    <cfif get_values.recordcount>
                                        <cfset value_ = "#Evaluate('get_values.property#j#')#">
                                    <cfelse>
                                        <cfset value_ = "">
                                    </cfif>
                                    <cfif len(Evaluate('get_labels.property#j#_type'))>
                                        <cfset validate_ = "#Evaluate('get_labels.property#j#_type')#">
                                    <cfelse>
                                        <cfset validate_ = "">
                                    </cfif>
                                    <cfif len(Evaluate('get_labels.property#j#_message'))>
                                        <cfset message_ = "#Evaluate('get_labels.property#j#_message')#">
                                    <cfelse>
                                        <cfset message_ = "">
                                    </cfif>
                                    <cfif len(Evaluate('get_labels.property#j#_range'))>
                                        <cfset max_ = "#Evaluate('get_labels.property#j#_range')#">
                                    <cfelse>
                                        <cfset max_ = "50">
                                    </cfif>
                                    <cfif isdefined("attributes.is_char_control") and attributes.is_char_control eq 1>
                                        <cfinput type="text" name="property#j#" id="property#j#" value="#value_#" style="width:250px;" validate="#validate_#" message="#message_#" maxlength="#max_#" onBlur="return(char_control_all(this));">
                                    <cfelse>
                                        <cfinput type="text" name="property#j#" id="property#j#" value="#value_#" style="width:250px;" validate="#validate_#" message="#message_#" maxlength="#max_#">
                                    </cfif>
                                </cfif>
                            </td>
                        </tr>
                    </cfloop>
                    <cfloop index="i" from="0" to="4" step="2">
                        <tr>
                            <td>
                                <cfset st = i+15>
                                <cfif len(Evaluate("get_labels.property#st#_name"))>
                                <cfoutput>#Evaluate("get_labels.property#st#_name")#</cfoutput>
                                <cfif Evaluate("get_labels.property#st#_req") eq 1>*</cfif>
                                </cfif>                                
                            </td>
                            <td>
                                <cfif len(Evaluate("get_labels.property#st#_name"))> 
                                <textarea name="<cfoutput>property#st#</cfoutput>" id="<cfoutput>property#st#</cfoutput>" style="width:150;height:50;"><cfif get_values.recordcount ><cfoutput>#Evaluate("get_values.property#st#")#</cfoutput></cfif></textarea>
                                </cfif> 
                            </td>
                            <td>
                                <cfset j = i+15+1>
                                <cfset j=st+1>
                                <cfif len(Evaluate("get_labels.property#j#_name")) >
									<cfoutput>#Evaluate("get_labels.property#j#_name")#</cfoutput>
                                    <cfif Evaluate("get_labels.property#j#_req") eq 1>*</cfif>
                                </cfif> 
                            </td>
                            <td>
                                <cfif len(Evaluate("get_labels.property#j#_name")) > 
                                	<textarea name="<cfoutput>property#j#</cfoutput>" id="<cfoutput>property#j#</cfoutput>" style="width:150;height:50;"><cfif get_values.recordcount><cfoutput>#Evaluate("get_values.property#j#")#</cfoutput></cfif></textarea>
                                </cfif> 
                			</td>
                		</tr>
                	</cfloop> 
                	<tr>
                		<td colspan="4"><cf_workcube_buttons is_upd='0' add_function='control_info()'></td>
                	</tr>     
                </table>
                </cfform>
            </td>
        </tr>
    </table>
</cfif>
<br/>
<script type="text/javascript">
	<cfif isdefined("attributes.is_char_control") and attributes.is_char_control eq 1>
		function char_control(fld)
		{
			toplam_ = fld.value.length;
			deger_ = fld.value;
			yasaklilar_ = 'Ş,ş,Ü,ü,Ğ,ğ,Ş,ş,ı,İ,ç,Ç,ö,Ö';
			if(toplam_>0)
			{
				tus_ = deger_.charAt(toplam_-1);
				cont_ = list_find(yasaklilar_,tus_);
				if(cont_>0)
				{
					alert('Türkçe Karakter Kullanamazsınız!');
					fld.value = fld.value.replace(tus_,'');
				}
			}
		}
		
		function char_control_all(fld)
		{
			toplam_ = fld.value.length;
			deger_ = fld.value;
			yasaklilar_ = 'Ü,ü,Ğ,ğ,Ş,ş,ı,İ,ö,Ö,ç,Ç';
			izinliler_ = 'U,u,G,g,S,s,i,I,o,O,c,C';
			if(toplam_>0)
			{
				for(var this_tus_=0; this_tus_<toplam_; this_tus_++)
				{
					tus_ = deger_.charAt(this_tus_);
					cont_ = list_find(yasaklilar_,tus_);
					if(cont_>0)
					{
						alert('Türkçe Karakter Kullanamazsınız!');
						izin_ = list_getat(izinliler_,cont_);
						fld.value = fld.value.replace(tus_,izin_);
					}
				}
			}
		}
	</cfif>
	
	function control_info()
	{
		<cfloop index="i" from="1" to="20">
			<cfif len(Evaluate("get_labels.property#i#_name")) and Evaluate("get_labels.property#i#_req") eq 1>
				if(document.send_form.<cfoutput>property#i#</cfoutput>.value.length==0)
					{
					alert('Lütfen Gerekli Alanları Tam Olarak Doldurunuz!');
					return false;
					}
			</cfif>
			<cfif len(Evaluate("get_labels.property#i#_range")) and len(Evaluate("get_labels.property#i#_range")) and isnumeric(Evaluate("get_labels.property#i#_range"))>
				<cfoutput>
					if(document.send_form.property#i#.value.length < #Evaluate("get_labels.property#i#_range")# || document.send_form.property#i#.value.length > #Evaluate("get_labels.property#i#_range")#)
					{
						<cfif len(Evaluate("get_labels.property#i#_message"))>
							alert('#Evaluate("get_labels.property#i#_message")#');
						<cfelse>
							alert('#Evaluate("get_labels.property#i#_name")# Alanını Doğru Giriniz!');
						</cfif>
						return false;
					}
				</cfoutput>
			</cfif>
		</cfloop>
		return true;
	}
</script>
