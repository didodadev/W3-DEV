<cfparam name="attributes.id" default="form_ul_#round(rand()*10000000)#">
<cfparam name="attributes.height" default="20">
<cfparam name="attributes.extra_select" default="">
<cfparam name="attributes.extra_checkbox" default="">
<cfparam name="attributes.onClick" default="">
<cfparam name="attributes.style" default="">
<cfparam name="attributes.radio_group" default="0">
<cfif isdefined("caller.attributes.type_id")>
	<cfset attributes.id_kontrol = "#attributes.id#_#caller.attributes.type_id#">
<cfelse>
	<cfset attributes.id_kontrol = "#attributes.id#_0">
</cfif>
<cfset degerim_ = thisTag.GeneratedContent>
<cfset thisTag.GeneratedContent =''>
<cfif thisTag.executionMode eq "start">
	<cfset caller.tr_sayac = caller.tr_sayac + 1>
    <cfset caller.li_sayac = 0>
    <cfif isdefined("attributes.title")>
        <cfset ul_title="#attributes.title#">
    <cfelseif attributes.id is 'form_ul_maxrows'>
        <cfset ul_title="#caller.getLang('main',1417)#"><!--- Kayıt Sayısı --->
<!---    <cfelse>
        <cfset ul_title="#attributes.id#">--->
    </cfif>
    <cfset ul_style = "height:#attributes.height#px; valign:top;">
    <cfif isdefined("caller.no_view_form_uls") and ListFindNoCase(caller.no_view_form_uls,attributes.id_kontrol)>
		<cfset ul_style = "#ul_style#display:none;">
        <cfset caller.hidden_tr_length = caller.hidden_tr_length + 1>
    </cfif>
    
    <cfif len(attributes.style)>
        <script type="text/javascript">
            <cfset ul_style = "#ul_style#;#attributes.style#">		
        </script>
    </cfif>

    <cfoutput>
        <tr id="#attributes.id#" <cfif isdefined("ul_title")> title="#ul_title#"</cfif> style="#ul_style#">
    </cfoutput>
    <cfif (isdefined("caller.no_edit_form_uls") and ListFindNoCase(caller.no_edit_form_uls,attributes.id_kontrol))>
        <cfset caller.ul_editable = 0>
    <cfelse>
        <cfset caller.ul_editable = 1>
    </cfif>
<cfelse>
		<cfoutput>
            #degerim_#
			<cfif (isdefined("caller.no_edit_form_uls") and ListFindNoCase(caller.no_edit_form_uls,attributes.id_kontrol))>
            <cfsavecontent variable="kontrol">#attributes.id#</cfsavecontent>
            <script>
                $("###attributes.id#").children("td").children("input,textarea").attr("readonly", "true");
                $("###attributes.id#").children("td").children("select").attr("disabled", "true");
                
                kontrol2 = '#kontrol#';
                
                if(<cfoutput>#listlen(attributes.extra_select,',')#</cfoutput> > 0)
                {
                    <cfoutput>
                    select_sayisi='#listlen(attributes.extra_select)#';
                    new_extra_list = '#attributes.extra_select#';
                        for(i=1; i<=select_sayisi; i++)
                        {
                            object_name=list_getat(new_extra_list,i);
                            hidden_alan2 = document.createElement('input');
                            hidden_alan2.name = object_name;
                            hidden_alan2.type = 'hidden';
                            hidden_alan2.id = object_name;
                            hidden_alan2.value = document.getElementById(object_name).options[document.getElementById(object_name).selectedIndex].value;
                            document.getElementById(kontrol2).appendChild(hidden_alan2);
                        }
                    </cfoutput>
                }
                
                if(<cfoutput>#listlen(attributes.extra_checkbox,',')#</cfoutput> > 0)
                {
                    <cfoutput>
                    select_sayisi='#listlen(attributes.extra_checkbox)#';
                    new_extra_list = '#attributes.extra_checkbox#';
                        for(i=1; i<=select_sayisi; i++)
                        {
                            object_name=list_getat(new_extra_list,i);
                            document.getElementById(object_name).disabled = 'true';
                            hidden_alan2 = document.createElement('input');
                            hidden_alan2.name = object_name;
                            hidden_alan2.type = 'hidden';
                            hidden_alan2.id = object_name;
                            if(document.getElementById(object_name).checked == true)
                                hidden_alan2.value = document.getElementById(object_name).value;
                            else
                                hidden_alan2.value = '';
                            document.getElementById(kontrol2).appendChild(hidden_alan2);
                        }
                    </cfoutput>
                }
                
                kontrol2 = kontrol2.replace('form_ul_','');
                              
				if(document.getElementById(kontrol2) == null) // Bir hucredeki butun alanlar ayni isimli radio buton ise isimleri uzerinden islem yapiyoruz. sayfadan gonderirken normal id gibi gonderiyoruz id=form_ul_property seklinde
				{
					for(i=0; i<document.getElementsByName(kontrol2).length; i++)
					{
						if(document.getElementsByName(kontrol2)[i].checked == true)
						{
							checked_value_ = document.getElementsByName(kontrol2)[i].value;
						}
						document.getElementsByName(kontrol2)[i].disabled = true;
					}
					hidden_alan2 = document.createElement('input');
					hidden_alan2.name = kontrol2;
					hidden_alan2.type = 'hidden';
					hidden_alan2.value = checked_value_;
					document.getElementById("form_ul_"+kontrol2).appendChild(hidden_alan2);
				}
				else
				{
					if (document.getElementById(kontrol2).type == 'select-one' || document.getElementById(kontrol2).type == 'select-multiple' || kontrol2 == 'process_stage')
					{
						if(document.getElementById(kontrol2).type == 'select-multiple')
							document.getElementById(kontrol2).disabled = "disabled";
						hidden_alan = document.createElement('input');
						hidden_alan.name = kontrol2;
						hidden_alan.type = 'hidden';
						hidden_alan.id = kontrol2;
						if(document.getElementById(kontrol2).selectedIndex != -1) // Bu kontrol multiple select'lerde seçili eleman -1 döndürdüğü için eklenmiştir
							hidden_alan.value = document.getElementById(kontrol2).options[document.getElementById(kontrol2).selectedIndex].value;
						document.getElementById("form_ul_"+kontrol2).appendChild(hidden_alan);
					}
					else if(document.getElementById(kontrol2).type == 'checkbox' && document.getElementById(kontrol2).checked == true) // Checkbox'larda gormesin yetkisinde checkbox'i kaybetmemek icin hidden olusturuyoruz.
					{
						document.getElementById(kontrol2).disabled = 'true';
						hidden_alan = document.createElement('input');
						hidden_alan.name = kontrol2;
						hidden_alan.type = 'hidden';
						hidden_alan.id = kontrol2;
						hidden_alan.value = document.getElementById(kontrol2).value;
						document.getElementById("form_ul_"+kontrol2).appendChild(hidden_alan);
					}
					else if(document.getElementById(kontrol2).type == 'checkbox' && document.getElementById(kontrol2).checked == false) // Checkbox'larda gormesin yetkisinde checkbox'i disabled ediyoruz.
						document.getElementById(kontrol2).disabled = 'true';
				}
            </script>
        </cfif>
        </cfoutput>
    </tr>
    <cfset caller.ul_editable = 1>
</cfif>
