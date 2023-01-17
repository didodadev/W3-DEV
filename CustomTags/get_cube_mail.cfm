<!---
Description :   
    Document Template 
Parameters :
    RELATION_TYPE       .-.- > action type 'required
	RELATION_TYPE_ID       .-.- > action id  'required
Syntax :
	<cf_get_cube_mail RELATION_TYPE='<string value>'  RELATION_TYPE_ID='<integer value>'>
Sample :
	<cf_get_cube_mail RELATION_TYPE='PROJECT_ID'  RELATION_TYPE_ID='1'>	
	
	created yunus ozay 05052009
 --->
<cfquery name="GET_ACTION_MAILS" datasource="#CALLER.DSN#">
	SELECT
		M.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		MAILS M,
		MAILS_RELATION MR,
		CUBE_MAIL CM,
		EMPLOYEES E
	WHERE
		MR.MAIL_ID = M.MAIL_ID AND
		CM.MAILBOX_ID = M.MAILBOX_ID AND
		CM.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		MR.RELATION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.relation_type#"> AND
		MR.RELATION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.relation_type_id#">
</cfquery>
<cfsavecontent variable="txt_">
	<cfoutput>#caller.getLang('main',2191)#</cfoutput>
    <div id="message_div" style="position:absolute;background-color:FFFF00;"></div>
</cfsavecontent>

<cfsavecontent variable="right_">
    <div id="top_menu_div" style="vertical-align:top;"></div>
</cfsavecontent>
<cf_box title="#txt_#" right_images="#right_#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="1">
	
           <div id="action_div" tagName="div" style="width:100%;height:99%;z-index:1;"></div>
       
</cf_box>
<script type="text/javascript">
function create_mail(mail_id,direction_type,mail_type,all_replies)
{
	goster(action_div);
	gizle(icon);
	goster(top_menu_div);
	var adres_ = '<cfoutput>#request.self#?fuseaction=correspondence.popup_create_cubemail&relation_type=#attributes.relation_type#&relation_type_id=#attributes.relation_type_id#</cfoutput>';
	
	if (arguments[0]!=null && arguments[0].length>0)
		var adres_ = adres_ + '&mail_id=' + mail_id;
		
	if (arguments[1]!=null && arguments[1].length>0)
		var adres_ = adres_ + '&direction_type=' + direction_type;
		
	if (arguments[2]!=null && arguments[2].length>0)
		var adres_ = adres_ + '&mail_type=' + mail_type;
		
	if (arguments[3]!=null && arguments[3].length>0)
		var adres_ = adres_ + '&all_replies=' + all_replies;
		
	AjaxPageLoad(adres_,'action_div','1','<cfoutput>#caller.getLang("main",2158)#</cfoutput>!'); 	
	get_top_menu('','1');
}
function get_mail(mail_id)
{	
	goster(top_menu_div);
	gizle(icon)
	var adres_ = '<cfoutput>#request.self#?fuseaction=correspondence.popup_get_cubemail&relation_type=#attributes.relation_type#&relation_type_id=#attributes.relation_type_id#</cfoutput>';
	var adres_ = adres_ + '&mail_id=' + mail_id;
	AjaxPageLoad(adres_,'action_div','1','<cfoutput>#caller.getLang("main",2159)#</cfoutput>!');	
	
	var adres_ = '<cfoutput>#request.self#?fuseaction=correspondence.popup_topmenu_cubemail&relation_type=#attributes.relation_type#&relation_type_id=#attributes.relation_type_id#</cfoutput>';
	var adres_ = adres_ + '&mail_id=' + mail_id;
	AjaxPageLoad(adres_,'top_menu_div','1','<cfoutput>#caller.getLang("main",2159)#</cfoutput>!');	 
}
function list_mail()
{
	var adres_ = '<cfoutput>#request.self#?fuseaction=correspondence.emptypopup_list_mail&relation_type=#attributes.relation_type#&relation_type_id=#attributes.relation_type_id#</cfoutput>';
	AjaxPageLoad(adres_,'action_div','1','<cfoutput>#caller.getLang("main",2160)#</cfoutput>!');	
}
function mail_gonder()
{		
	//get_top_menu();
	goster(top_menu_div);
	gizle(icon);
	var adres_ = '<cfoutput>#request.self#?fuseaction=correspondence.popup_create_cubemail&relation_type=#attributes.relation_type#&relation_type_id=#attributes.relation_type_id#</cfoutput>';	
  	AjaxPageLoad(adres_,'action_div','1','<cfoutput>#caller.getLang("main",2158)#</cfoutput>');	

}
function get_top_menu(mail_id,new_mail)
{
	var adres_ = '<cfoutput>#request.self#?fuseaction=correspondence.popup_topmenu_cubemail&relation_type=#attributes.relation_type#&relation_type_id=#attributes.relation_type_id#</cfoutput>';
	if (arguments[0]!=null && mail_id !='')
		{
		var adres_ = adres_ + '&mail_id=' + mail_id;
		AjaxPageLoad(adres_,'top_menu_div','1','<cfoutput>#caller.getLang("main",2161)#</cfoutput>!'); 
		}
	else if(arguments[1]!=null)
		{
		var adres_ = adres_ + '&is_new_mail=1';
		AjaxPageLoad(adres_,'top_menu_div','1','<cfoutput>#caller.getLang("main",2161)#</cfoutput>!'); 
		}
	else
		AjaxPageLoad(adres_,'top_menu_div','1','<cfoutput>#caller.getLang("main",2161)#</cfoutput>!');	
}
function geri_don()
{
list_mail();
}
list_mail();
function get_templates()
{
	gizle_goster(template_div);
}
function get_signature()
{
	gizle_goster(signature_div);
}
function get_associate()
{
	gizle_goster(associate_div);
}
function delete_mail(mail_id,relation_type,relation_type_id)
{
	var adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.emptypopup_delete_cubemail';
	var adres_ = adres_ + '&mail_id=' + mail_id;
	var adres_ = adres_ + '&relation_type=' + relation_type;
	var adres_ = adres_ + '&relation_type_id=' + relation_type_id;
	AjaxPageLoad(adres_,'action_div','1','<cfoutput>#caller.getLang("main",292)#</cfoutput>!');	
}
</script>