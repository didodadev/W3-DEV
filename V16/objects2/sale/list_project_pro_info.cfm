<cfparam name="attributes.type_id" default="-10">
<cfquery name="GET_LABELS" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_INFOPLUS_NAMES
	WHERE	
		OWNER_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
</cfquery>
<cfif GET_LABELS.RECORDCOUNT>
        <table id="info_table">
          <tr>
            <td valign="top">
                <table>
                  <cfform action="#request.self#?fuseaction=objects2.add_info_plus_project_act" method="post" name="send_form">
                  <tr>
				  	<td><cf_get_lang no='451.Proje Adı'></td>
					<td colspan="3"><cfinput type="text" message="Proje Girmelisiniz!" value="" name="project_head" style="width:615px;"></td>
				  </tr>
				  <tr>
				  	<td><cf_get_lang no='452.Proje Detayı'></td>
					<td colspan="3"><cfinput type="text" message="Proje Detayı!" value="" name="project_detail" style="width:615px;"></td>
				  </tr>
				  <cfloop index="i" from="1" to="7">
                    <tr>
                      <td width="100">
                        <cfif len(Evaluate("GET_LABELS.PROPERTY#i#_NAME"))>
                          <cfoutput>#Evaluate("GET_LABELS.PROPERTY#i#_NAME")#</cfoutput>
						  <cfif Evaluate("GET_LABELS.PROPERTY#i#_REQ") eq 1>*</cfif>
                        </cfif>
                      </td>
                      <td width="175">
						<cfif len(Evaluate("GET_LABELS.PROPERTY#i#_NAME"))>
						  <cfset value_ = "">
						  <cfif len(Evaluate('GET_LABELS.PROPERTY#i#_type'))>
						  	<cfset validate_ = "#Evaluate('GET_LABELS.PROPERTY#i#_type')#">
						  <cfelse>
						  	<cfset validate_ = "">
						  </cfif>
						  <cfif len(Evaluate('GET_LABELS.PROPERTY#i#_message'))>
						  	<cfset message_ = "#Evaluate('GET_LABELS.PROPERTY#i#_message')#">
						  <cfelse>
						  	<cfset message_ = "">
						  </cfif>
						  <cfif len(Evaluate('GET_LABELS.PROPERTY#i#_range'))>
						  	<cfset max_ = "#Evaluate('GET_LABELS.PROPERTY#i#_range')#">
						  <cfelse>
						  	<cfset max_ = "50">
						  </cfif>
							<cfif isdefined("attributes.is_char_control") and attributes.is_char_control eq 1>
								<cfinput type="text" name="PROPERTY#i#" value="#value_#" style="width:250px;" validate="#validate_#" message="#message_#" maxlength="#max_#" onBlur="return(char_control_all(this));">
							<cfelse>
								<cfinput type="text" name="PROPERTY#i#" value="#value_#" style="width:250px;" validate="#validate_#" message="#message_#" maxlength="#max_#">
							</cfif>
                        </cfif>
                      </td>
                      <td width="100">
                        <cfset j=i+7>
                        <cfif len(Evaluate("GET_LABELS.PROPERTY#j#_NAME"))>
                          <cfoutput>#Evaluate("GET_LABELS.PROPERTY#j#_NAME")#</cfoutput>
						  <cfif Evaluate("GET_LABELS.PROPERTY#j#_REQ") eq 1>*</cfif>
                        </cfif>
                      </td>
                      <td>
                        <cfif len(Evaluate("GET_LABELS.PROPERTY#j#_NAME"))>
						  	<cfset value_ = "">
						  <cfif len(Evaluate('GET_LABELS.PROPERTY#j#_type'))>
						  	<cfset validate_ = "#Evaluate('GET_LABELS.PROPERTY#j#_type')#">
						  <cfelse>
						  	<cfset validate_ = "">
						  </cfif>
						  <cfif len(Evaluate('GET_LABELS.PROPERTY#j#_message'))>
						  	<cfset message_ = "#Evaluate('GET_LABELS.PROPERTY#j#_message')#">
						  <cfelse>
						  	<cfset message_ = "">
						  </cfif>
						  <cfif len(Evaluate('GET_LABELS.PROPERTY#j#_range'))>
						  	<cfset max_ = "#Evaluate('GET_LABELS.PROPERTY#j#_range')#">
						  <cfelse>
						  	<cfset max_ = "50">
						  </cfif>
						<cfif isdefined("attributes.is_char_control") and attributes.is_char_control eq 1>
							<cfinput type="text" name="PROPERTY#j#" value="#value_#" style="width:250px;" validate="#validate_#" message="#message_#" maxlength="#max_#" onBlur="return(char_control_all(this));">
						<cfelse>
							<cfinput type="text" name="PROPERTY#j#" value="#value_#" style="width:250px;" validate="#validate_#" message="#message_#" maxlength="#max_#">
						</cfif>
                        </cfif>
                      </td>
                    </tr>
                  </cfloop>
                  <cfloop index="i" from="0" to="4" step="2">
                    <tr>
                      <td>
                        <cfset st = i+15>
                        <cfif len(Evaluate("GET_LABELS.PROPERTY#st#_NAME"))>
                          <cfoutput>#Evaluate("GET_LABELS.PROPERTY#st#_NAME")#</cfoutput>
						  <cfif Evaluate("GET_LABELS.PROPERTY#st#_REQ") eq 1>*</cfif>
                        </cfif>
						
                      </td>
                      <td>
                        <cfif len(Evaluate("GET_LABELS.PROPERTY#st#_NAME"))> 
                          <textarea name="<cfoutput>PROPERTY#st#</cfoutput>" id="<cfoutput>PROPERTY#st#</cfoutput>" style="width:150;height:50;"><cfif GET_VALUES.recordcount ><cfoutput>#Evaluate("GET_VALUES.PROPERTY#st#")#</cfoutput></cfif></textarea>
                         </cfif> 
                      </td>
                      <td>
  						<cfset j = i+15+1>
                       <cfset j=st+1>
                        <cfif len(Evaluate("GET_LABELS.PROPERTY#j#_NAME")) >
                          <cfoutput>#Evaluate("GET_LABELS.PROPERTY#j#_NAME")#</cfoutput>
						  <cfif Evaluate("GET_LABELS.PROPERTY#j#_REQ") eq 1>*</cfif>
                         </cfif> 
                      </td>
                      <td>
                        <cfif len(Evaluate("GET_LABELS.PROPERTY#j#_NAME")) > 
                          <textarea name="<cfoutput>PROPERTY#j#</cfoutput>" id="<cfoutput>PROPERTY#j#</cfoutput>" style="width:150;height:50;"><cfif GET_VALUES.recordcount><cfoutput>#Evaluate("GET_VALUES.PROPERTY#j#")#</cfoutput></cfif></textarea>
                         </cfif> 
                      </td>
                    </tr>
                  </cfloop> 
                  <tr>
                    <td colspan="4"><cf_workcube_buttons is_upd='0' add_function='control_info()'></td>
                  </tr> 
				  </cfform> 
                </table>
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
			alert("<cf_get_lang no='1043.Türkçe Karakter Kullanamazsınız'>!");
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
				alert("<cf_get_lang no='1043.Türkçe Karakter Kullanamazsınız'>!");
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
		<cfif len(Evaluate("GET_LABELS.PROPERTY#i#_NAME")) and Evaluate("GET_LABELS.PROPERTY#i#_REQ") eq 1>
			if(document.send_form.<cfoutput>PROPERTY#i#</cfoutput>.value.length==0)
				{
				alert("<cf_get_lang no='1044.Lütfen Gerekli Alanları Tam Olarak Doldurunuz'>!");
				return false;
				}
		</cfif>
		<cfif len(Evaluate("GET_LABELS.PROPERTY#i#_RANGE")) and len(Evaluate("GET_LABELS.PROPERTY#i#_RANGE")) and isnumeric(Evaluate("GET_LABELS.PROPERTY#i#_RANGE"))>
			<cfoutput>
				if(document.send_form.PROPERTY#i#.value.length<#Evaluate("GET_LABELS.PROPERTY#i#_RANGE")# || document.send_form.PROPERTY#i#.value.length>#Evaluate("GET_LABELS.PROPERTY#i#_RANGE")#)
					{
					<cfif len(Evaluate("GET_LABELS.PROPERTY#i#_MESSAGE"))>
						alert('#Evaluate("GET_LABELS.PROPERTY#i#_MESSAGE")#');
					<cfelse>
						alert('#Evaluate("GET_LABELS.PROPERTY#i#_NAME")# Alanını Doğru Giriniz!');
					</cfif>
					return false;
					}
			</cfoutput>
		</cfif>
	</cfloop>
	return true;
}
</script>
