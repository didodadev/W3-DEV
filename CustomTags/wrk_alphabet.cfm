<!--- 
FBS 20120905 Olusturan kim Bilmiyorum ama popuplardaki ust blokta alfabetik filtreleme yapmayi saglar.
Gruplar ve Rakamlar seklinde eklenebilecek 2 secenek daha olmasi gerekli (tip:group)
 --->
<cfset alhabet_list = 'A,B,C,Ç,D,E,F,G,Ğ,H,I,İ,J,K,L,M,N,O,Ö,P,Q,R,S,Ş,T,U,Ü,V,W,X,Y,Z'>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_group" default="">
<cfparam name="attributes.popup_box" default="0">
<cfparam name="attributes.modal_id" default="#caller.attributes.modal_id?:''#">
<cfset global_url_string = ''>
<cfloop list="#attributes.keyword#" index="url_str">
	<cfset global_url_string = "#global_url_string##Evaluate('caller.#url_str#')#">
</cfloop>
<ul class="alphabet_list">
    <cfoutput>
    <cfloop list="#alhabet_list#" index="letter">
        <li>
            <cfif attributes.popup_box eq 1>
                <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=#caller.attributes.fuseaction#&keyword=#letter##global_url_string#', #attributes.modal_id#)">#letter#</a>
            <cfelse>
                <a href="#request.self#?fuseaction=#caller.attributes.fuseaction#&keyword=#letter##global_url_string#">#letter#</a>
            </cfif>
        </li>
     </cfloop>
     <!--- <cfif Len(attributes.is_group) and attributes.is_group eq 1>
         <li><a href="#request.self#?fuseaction=#caller.attributes.fuseaction#&is_group=group#global_url_string#">G r u p l a r</a></li><!--- Dile Alinmali --->
     </cfif> --->
    </cfoutput> 
</ul>
