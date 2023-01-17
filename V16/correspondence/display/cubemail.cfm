<cf_xml_page_edit>
<cfsetting showdebugoutput="no">
<cfquery name="emp_mail_list" datasource="#DSN#">
	SELECT 
		*
	FROM 
		CUBE_MAIL 
	WHERE 
		EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfloop query="emp_mail_list">
<cfif present_isactive eq 1>
	<cfset is_present_isactive = 1>
</cfif>
</cfloop>
<cfif not emp_mail_list.recordcount>
	<cfif isdefined("attributes.ajax")>
		<cflocation url="#request.self#?fuseaction=correspondence.list_mymails&ajax=1" addtoken="no">
	<cfelse>
		<cflocation url="#request.self#?fuseaction=correspondence.list_mymails" addtoken="no">
	</cfif>
</cfif>
<cfif emp_mail_list.recordcount and  (not len(emp_mail_list.password) or not len(emp_mail_list.pop) or not len(emp_mail_list.smtp))>
	<cfif isdefined("attributes.ajax")>
		<cflocation url="#request.self#?fuseaction=correspondence.list_mymails&ajax=1" addtoken="no">
	<cfelse>
		<cflocation url="#request.self#?fuseaction=correspondence.list_mymails" addtoken="no">
	</cfif>
</cfif>
<input type="hidden" name="last_action" id="last_action" value="list_mail(-4)">
<input type="hidden" name="last_page" id="last_page" value="">

<script type="text/javascript">
function list_mail(folder_id,order_type,is_search,mail_from,mail_to,startdate,finishdate,mail_subject,mail_body,mail_file,page)
{
	get_list_width_ = document.body.offsetWidth - 255;
	if(arguments[1]!=null)
		order_type_ = order_type;
	else
		order_type_ = 0;
	
	gizle(message_div_main);
	gizle(working_div_main);
	var last_action1 = "list_mail(";
	if (arguments[0]!=null)
	{
		var last_action1 = last_action1 + folder_id;
	}
	if (arguments[2]!=null)
	{
		var last_action1 = last_action1 + ',' + '"' + order_type_ + '"';
		var last_action1 = last_action1 + ',' + '"' + is_search + '"';
		var last_action1 = last_action1 + ',' + '"' + mail_from + '"';
		var last_action1 = last_action1 + ',' + '"' + mail_to + '"';
		var last_action1 = last_action1 + ',' + '"' + startdate + '"';
		var last_action1 = last_action1 + ',' + '"' + finishdate + '"';
		var last_action1 = last_action1 + ',' + '"' + mail_subject + '"';
		var last_action1 = last_action1 + ',' + '"' + mail_body + '"';
		var last_action1 = last_action1 + ',' + '"' + mail_file + '"';			
	}
	//page parametresi ekledim py20121123
	if (arguments[10]!=null)
			var last_action1 = last_action1 + ',' + '"' + page + '"';			
	var last_action1 = last_action1 + ")";
	window.document.getElementById("last_action").value = last_action1;
	
	goster(action_div);
	gizle(search_div);
	var adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.emptypopup_list_mail';
	var adres_ = adres_ + '&folder_id=' + folder_id;
	var adres_ = adres_ + '&order_type=' + order_type_;
	var adres_ = adres_ + '&list_width=' + get_list_width_;
	if (arguments[2]!=null)
	{
		var adres_ = adres_ + '&mail_from=' + mail_from;
		var adres_ = adres_ + '&mail_to=' + mail_to;
		var adres_ = adres_ + '&startdate=' + startdate;
		var adres_ = adres_ + '&finishdate=' + finishdate;
		var adres_ = adres_ + '&mail_subject=' + mail_subject;
		var adres_ = adres_ + '&mail_body=' + mail_body;
		var adres_ = adres_ + '&mail_file=' + mail_file;
	}
	if (arguments[10]!=null)
		var adres_ = adres_ + '&page=' + page;
	AjaxPageLoad(adres_,'action_div','1', "<cf_get_lang dictionary_id='29957.Mailler Listeleniyor'>!");
	get_top_menu('','',folder_id);
	get_search_icerik();
}
function check_mail()
{
	document.getElementById('last_page').value = 'correspondence.emptypopup_list_mail';
	get_wrk_message_div("CubeMail","Mail Alma İşlemi Başladı!");
	document.form_get_mail.target = 'mail_receive_frame';
	document.form_get_mail.submit();
	check_mail_ = setTimeout("check_mail()", 1800000);
}
function check_mail_repeat()
{
	check_mail();
}

function create_mail(mail_id,direction_type,mail_type,all_replies,pid)
{
	document.getElementById('last_page').value = 'correspondence.popup_create_cubemail';
	goster(action_div);
	gizle(search_div);
	gizle(message_div_main);
	var adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_create_cubemail';
	
	if (arguments[0]!=null)
		var adres_ = adres_ + '&mail_id=' + mail_id;
		
	if (arguments[1]!=null)
		var adres_ = adres_ + '&direction_type=' + direction_type;
		
	if (arguments[2]!=null)
		var adres_ = adres_ + '&mail_type=' + mail_type;
		
	if (arguments[3]!=null)
		var adres_ = adres_ + '&all_replies=' + all_replies;
		
	if(arguments[4]!=null)
		var adres_ ='<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_create_cubemail&pid=' + pid;
		
	AjaxPageLoad(adres_,'action_div','1', "<cf_get_lang dictionary_id='29955.Mail Oluşturuluyor'>"); 
	get_top_menu('','1');
}
function get_mail(mail_id,folder_id)
{
	goster(action_div);
	gizle(search_div); 
	var adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_get_cubemail';
	var adres_ = adres_ + '&mail_id=' + mail_id;
	AjaxPageLoad(adres_,'action_div','1', "<cf_get_lang dictionary_id='29956.Mail Açılıyor'>");
	 
	var adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_topmenu_cubemail';
	var adres_ = adres_ + '&mail_id=' + mail_id;
	var adres_ = adres_ + '&folder_id=' + folder_id;
	AjaxPageLoad(adres_,'top_menu_div','1', "<cf_get_lang dictionary_id='29956.Mail Açılıyor'>");
}
function get_left_menu()
{
	var adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_leftmenu_cubemail';
	AjaxPageLoad(adres_,'left_menu_div','1', "<cf_get_lang dictionary_id='54764.Klasörler Listeleniyor'>");
}
function get_top_menu(mail_id,new_mail,folder_id)
{
	var adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_topmenu_cubemail'; ;
	if (arguments[0]!=null && mail_id !='')
	{
		var adres_ = adres_ + '&mail_id=' + mail_id;
		AjaxPageLoad(adres_,'top_menu_div','1', "<cf_get_lang dictionary_id='29958.Menü Yükleniyor'>!"); 
	}
	else if(arguments[1]!=null)
	{
		var adres_ = adres_ + '&is_new_mail=1';
		AjaxPageLoad(adres_,'top_menu_div','1', "<cf_get_lang dictionary_id='29958.Menü Yükleniyor'>!");
	}
	else if(arguments[2]!=null)
	{
		var adres_ = adres_ + '&folder_id='+folder_id;
		AjaxPageLoad(adres_,'top_menu_div','1', "<cf_get_lang dictionary_id='29958.Menü Yükleniyor'>!");
	}
	else
		AjaxPageLoad(adres_,'top_menu_div','1', "<cf_get_lang dictionary_id='29958.Menü Yükleniyor'>!");
}
function add_folder(type,id)
{
	var adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_add_folder';
	var adres_ = adres_ + '&type=' + type;
	var adres_ = adres_ + '&id=' + id;
	AjaxPageLoad(adres_,'add_folder_div','1', "<cf_get_lang dictionary_id='58892.Lutfen Bekleyin'>");
}
function upd_folder(type,id)
{
	var adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.popup_upd_folder';
	var adres_ = adres_ + '&type=' + type;
	var adres_ = adres_ + '&id=' + id;
	AjaxPageLoad(adres_,'add_folder_div','1',"<cf_get_lang dictionary_id='58892.Lutfen Bekleyin'>");
}
function select_all()
{
	var c_list_len = document.getElementsByName('mail_id_list').length;
	if(c_list_len == 0)
	{
		alert('Seçilecek Mail Bulunamadı!');
		return false;
	}
	else if(c_list_len == 1)
	{
		if(document.getElementById('mail_id_list').checked == true)
		{
			document.getElementById('mail_id_list').checked = false;
		}
		else
		{
			document.getElementById('mail_id_list').checked = true;
		}
	}
	else if(c_list_len > 1)
	{
		for(var i=1; i<=c_list_len; i++)
		{
			if(document.all.mail_id_list[i-1].checked == true)
			{
				document.all.mail_id_list[i-1].checked = false;
			}
			else
			{
				document.all.mail_id_list[i-1].checked = true;
			}
		}
	}
}
function delete_mail(folder_id,mail_id,is_single,next_mail_id)
{
	var adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.emptypopup_delete_cubemail';
	var adres_ = adres_ + '&folder_id=' + folder_id;
	var adres_ = adres_ + '&mail_ids_list=' + mail_id;
	var adres_ = adres_ + '&is_single=' + is_single;
	var adres_ = adres_ + '&next_mail_id=' + next_mail_id;
	AjaxPageLoad(adres_,'action_div','1','Mailler Siliniyor!');
}
function delete_all(folder_id)
{
	var adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.emptypopup_delete_cubemail';
	var mail_ids_list = '';
	var c_list_len = document.getElementsByName('mail_id_list').length;
	if(c_list_len == 0)
		{
		alert("<cf_get_lang dictionary_id='54765.Silinecek Mail Bulunamadı'>!");
		return false;
		}
	else if(c_list_len == 1)
		{
		if(document.getElementById('mail_id_list').checked == true)
			{
			var mail_ids_list = mail_ids_list + document.getElementById('mail_id_list').value + ',';
			}
		else
			{
			alert("<cf_get_lang dictionary_id='54765.Silinecek Mail Bulunamadı'>!");
			return false;
			}
		}
	else if(c_list_len > 1)
		{
		var mail_sayisi_ = 0;
		for(var i=1; i<=c_list_len; i++)
			{
				if(document.all.mail_id_list[i-1].checked == true)
					{
					var mail_ids_list = mail_ids_list + document.all.mail_id_list[i-1].value + ',';
					var mail_sayisi_ = 1;
					}
			}
			if(mail_sayisi_==0)
				{
				alert("<cf_get_lang dictionary_id='54765.Silinecek Mail Bulunamadı'>!");
				return false;
				}		
		}
	var adres_ = adres_ + '&folder_id=' + folder_id;
	var adres_ = adres_ + '&mail_ids_list=' + mail_ids_list;
	AjaxPageLoad(adres_,'action_div','1', "<cf_get_lang dictionary_id='54769.Mailler Siliniyor'>!");
}

function read_all_folder(folder_id,read_type)
{
	var adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.emptypopup_read_cubemail';
	var mail_ids_list = '';
	var c_list_len = document.getElementsByName('mail_id_list').length;
	if(c_list_len == 0)
		{
		alert("<cf_get_lang dictionary_id='54766.İşlem Yapılacak Mail Bulunamadı'>!");
		return false;
		}
	else if(c_list_len == 1)
		{
		if(document.getElementById('mail_id_list').checked == true)
			{
			var mail_ids_list = mail_ids_list + document.getElementById('mail_id_list').value + ',';
			}
		else
			{
			alert("<cf_get_lang dictionary_id='54766.İşlem Yapılacak Mail Bulunamadı'>!");
			return false;
			}
		}
	else if(c_list_len > 1)
		{
		var mail_sayisi_ = 0;
		for(var i=1; i<=c_list_len; i++)
			{
				if(document.all.mail_id_list[i-1].checked == true)
					{
					var mail_ids_list = mail_ids_list + document.all.mail_id_list[i-1].value + ',';
					var mail_sayisi_ = 1;
					}
			}
			if(mail_sayisi_==0)
				{
				alert("<cf_get_lang dictionary_id='54766.İşlem Yapılacak Mail Bulunamadı'>!");
				return false;
				}		
		}
	var adres_ = adres_ + '&folder_id=' + folder_id;
	var adres_ = adres_ + '&mail_ids_list=' + mail_ids_list;
	var adres_ = adres_ + '&read_type=' + read_type;
	AjaxPageLoad(adres_,'action_div','1', "<cf_get_lang dictionary_id='57704.İşlem Yapılıyor'>!");
}

function delete_all_folder(folder_id)
{
	answer = confirm ("<cf_get_lang dictionary_id='54767.Klasördeki bütün mailler silinecek'>.<cf_get_lang dictionary_id='54768.Bu işlemi yapmak istediğinize emin misiniz'>?");
	if (answer)
	{
		var adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.emptypopup_delete_cubemail';
		var adres_ = adres_ + '&folder_id=' + folder_id;
		var adres_ = adres_ + '&is_all_delete=1';
		AjaxPageLoad(adres_,'action_div','1', "<cf_get_lang dictionary_id='Mailler Siliniyor'>!");
	}
	else
		return;
}

function move_all(folder_id)
{
	if(document.all.new_folder.value=='')
		{
		alert("<cf_get_lang dictionary_id='54770.Taşınacak Klasör Seçmelisiniz'>!");
		return false;
		}
	
	var adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.emptypopup_move_cubemail';
	var mail_ids_list = '';
	var c_list_len = document.getElementsByName('mail_id_list').length;
	if(c_list_len == 0)
		{
		alert("<cf_get_lang dictionary_id='54771.Taşınacak Mail Bulunamadı'>!");
		return false;
		}
	else if(c_list_len == 1)
		{
		if(document.getElementById('mail_id_list').checked == true)
			{
			var mail_ids_list = mail_ids_list + document.getElementById('mail_id_list').value + ',';
			}
		else
			{
			alert("<cf_get_lang dictionary_id='54771.Taşınacak Mail Bulunamadı'>!");
			return false;
			}
		}
	else if(c_list_len > 1)
		{
		var mail_sayisi_ = 0;
		for(var i=1; i<=c_list_len; i++)
			{
				if(document.all.mail_id_list[i-1].checked == true)
					{
					var mail_ids_list = mail_ids_list + document.all.mail_id_list[i-1].value + ',';
					var mail_sayisi_ = 1;
					}
			}
			if(mail_sayisi_==0)
				{
				alert("<cf_get_lang dictionary_id='54771.Taşınacak Mail Bulunamadı'>!");
				return false;
				}		
		}
	var adres_ = adres_ + '&folder_id=' + folder_id;
	var adres_ = adres_ + '&new_folder_id=' + document.all.new_folder.value;
	var adres_ = adres_ + '&mail_ids_list=' + mail_ids_list;
	AjaxPageLoad(adres_,'action_div','1', "<cf_get_lang dictionary_id='54774.Mailler Taşınıyor'>");
}

function ajaxpaging(page,folder_id,order_type,mail_from,mail_to,startdate,finishdate,mail_subject,mail_body,mail_file)
{
	get_list_width_ = document.body.offsetWidth - 255;
	var adres_ = '<cfoutput>#request.self#?fuseaction=correspondence.emptypopup_list_mail</cfoutput>';
	if(arguments[2]!=null)
		order_type_ = order_type;
	else
		order_type_ = 0;
	var adres_ = adres_ + '&folder_id=' + folder_id;
	var adres_ = adres_ + '&order_type=' + order_type_;
	var adres_ = adres_ + '&page=' + page;
	var adres_ = adres_ + '&list_width=' + get_list_width_;
	if (arguments[3]!=null)
		{
		var adres_ = adres_ + '&mail_from=' + mail_from;
		var adres_ = adres_ + '&mail_to=' + mail_to;
		var adres_ = adres_ + '&startdate=' + startdate;
		var adres_ = adres_ + '&finishdate=' + finishdate;
		var adres_ = adres_ + '&mail_subject=' + mail_subject;
		var adres_ = adres_ + '&mail_body=' + mail_body;
		var adres_ = adres_ + '&mail_file=' + mail_file;
		}
	
	var last_action1 = "list_mail(";
	var last_action1 = last_action1 + folder_id;
	var last_action1 = last_action1 + ',' + '"' + order_type_ + '"';
	var last_action1 = last_action1 + ',' + '""';
	var last_action1 = last_action1 + ',' + '""';
	var last_action1 = last_action1 + ',' + '""';
	var last_action1 = last_action1 + ',' + '""';
	var last_action1 = last_action1 + ',' + '""';
	var last_action1 = last_action1 + ',' + '""';
	var last_action1 = last_action1 + ',' + '""';
	var last_action1 = last_action1 + ',' + '""';	
	var last_action1 = last_action1 + ',' + '"' + page + '"';		
	var last_action1 = last_action1 + ")";

	window.document.getElementById("last_action").value = last_action1;
	AjaxPageLoad(adres_,'action_div',1)
}
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
function geri_don()
{
	var son_hareket = window.document.getElementById("last_action").value;
	eval(son_hareket);
}
function get_search_icerik()
{
	var adres_ = '<cfoutput>#request.self#?fuseaction=correspondence.emptypopup_cubemail_search</cfoutput>';
	AjaxPageLoad(adres_,'search_div');
}
function get_search_div()
{
	gizle_goster(search_div);
	gizle_goster(action_div);
}

function get_mail_adress()
{
	create_mail();
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=send_mail.emp_id&names=send_mail.emp_name');
}
</script>
<div id="message_div"></div>
<cfform name="form_get_mail" action="#request.self#?fuseaction=correspondence.emptypopup_check_cubemail" method="post"></cfform>
<table class="dph">
	<tr>
    	<td class="dpht"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.cubemail"><img border="0" src="/images/mail/cubemail.jpg"></a></td>
        <td class="dphb"><div id="top_menu_div"></div></td>
    </tr>
</table>
<table class="dpm">
	<tr>
		<td width="200" valign="top"><div id="left_menu_div" style="height:auto;"></div></td>
		<td valign="top">
            <div id="search_div" name="search_div" style="display:none;"></div>
            <div id="action_div" name="action_div" style="height:auto;"></div>
		</td>
	</tr>
</table>
<iframe src="" name="mail_receive_frame" id="mail_receive_frame" style="display:none;" width="0" height="0"></iframe>
<script type="text/javascript">
<cfif isdefined('attributes.pid')>
	create_mail('','','','','<cfoutput>#attributes.pid#</cfoutput>'); 
	get_left_menu();
<cfelse>
	get_left_menu();
	get_top_menu('','');
	<cfif not isdefined("is_present_isactive")>
		list_mail(-4);
	</cfif> 
	check_mail_repeat();
</cfif>
</script>

