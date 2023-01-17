<cf_get_lang_set module_name="member">
<cfquery name="get_hobby" datasource="#DSN#">
  SELECT 
  	* 
  FROM 
  	SETUP_HOBBY
</cfquery>
<cfquery name="get_company_member_hobbies" datasource="#dsn#"> 
	SELECT HOBBY_ID
	FROM COMPANY_PARTNER_HOBBY
	WHERE PARTNER_ID=#attributes.pid#
</cfquery>
<cfset liste = valuelist(get_company_member_hobbies.hobby_id)>

<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Hobiler',30648)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=member.emptypopup_company_partner_hobbies_upd&pid=#attributes.pid#" method="post" name="hobby">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='30509.Hobi'></td>
                    <th width="20"><cf_get_lang dictionary_id='58693.Seç'></td>
                </tr>
            </thead>
            <tbody>
            <cfoutput query="get_hobby">
                <tr>
                    <td>#get_hobby.HOBBY_NAME#</td>
                    <td><input type="checkbox" name="HOBBY" id="HOBBY" value="#get_hobby.HOBBY_ID#"<cfif liste contains HOBBY_ID>checked</cfif>></td>
                </tr>
            </cfoutput>
            </tbody>
        </cf_grid_list>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('hobby' , #attributes.modal_id#)"),DE(""))#">
        </cf_box_footer>    
    </cfform>
</cf_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

