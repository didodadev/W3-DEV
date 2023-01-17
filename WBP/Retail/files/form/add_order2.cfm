<link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.base.css" />
<link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.energyblue.css" />
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcore.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdata.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxbuttons.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxscrollbar.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxmenu.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.edit.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.selection.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsresize.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsreorder.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.filter.js"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxnumberinput_new.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxinput.js"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxlistbox.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcheckbox.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxtooltip.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdropdownlist.js"></script>


<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.grouping.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.aggregates.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/scripts/demos.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/demos/jqxgrid/localization.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>

<!--- VADE DUZENLEME --->
<cfquery name="upd_" datasource="#dsn3#">
UPDATE
	ORDER_ROW
SET
	DUEDATE = (SELECT P.DUEDAY FROM #dsn1#.PRODUCT P WHERE P.PRODUCT_ID = ORDER_ROW.PRODUCT_ID)
WHERE
	DUEDATE IS NULL AND
    ORDER_ID IN (#order_id_list#)
</cfquery>


<cfquery name="get_order_row" datasource="#dsn3#">
	SELECT 
    	ORR.*,
        O.ORDER_ID,
        O.ORDER_DATE 
    FROM 
    	ORDER_ROW ORR,
        ORDERS O
    WHERE 
    	O.ORDER_ID = ORR.ORDER_ID AND 
        ORR.DUEDATE > 0 AND
    	O.ORDER_ID IN (#order_id_list#)
    ORDER BY 
    	ORR.ORDER_ID ASC
</cfquery>
<cfset last_invoice_ = 0>
<cfset last_invoice_total_ = 0>
<cfset last_invoice_day_ = 0>
<cfset invoice_vade_list = ''>
<cfoutput query="get_order_row">
    <cfset last_invoice_total_ = last_invoice_total_ + (NETTOTAL * DUEDATE)>
    <cfset last_invoice_day_ = last_invoice_day_ + NETTOTAL>
    <cfset invoice_vade_list = listappend(invoice_vade_list,DUEDATE)>
	<cfif currentrow eq get_order_row.recordcount or ORDER_ID neq ORDER_ID[currentrow+1]>
    	<cfset invoice_vade_list = listdeleteduplicates(invoice_vade_list)>
        <cfif last_invoice_day_ gt 0>
            <cfquery name="upd_" datasource="#dsn3#">
                UPDATE
                    ORDERS
                SET
                    <cfif listlen(invoice_vade_list) eq 1>
                    DUE_DATE = #DATEADD('d',invoice_vade_list,ORDER_DATE)#
                    <cfelse>
                    DUE_DATE = #DATEADD('d',ceiling(last_invoice_total_ / last_invoice_day_),ORDER_DATE)#
                    </cfif>
                WHERE
                    ORDER_ID = #ORDER_ID#
            </cfquery>
        </cfif>
        <cfset last_invoice_ = 0>
		<cfset last_invoice_total_ = 0>
        <cfset last_invoice_day_ = 0>
		<cfset invoice_vade_list = ''>
    </cfif>
</cfoutput>
<!--- VADE DUZENLEME --->


<cfquery name="order_codes" datasource="#dsn3#">
	SELECT
        DISTINCT
        O.ORDER_CODE
    FROM
        ORDERS AS O
    WHERE
    	O.ORDER_ID IN (#order_id_list#)
</cfquery>
<cfset order_code_list = valuelist(order_codes.ORDER_CODE)>

<cfif isdefined("attributes.is_from_add")>
	<script>
		window.opener.document.search_product.order_code.value = '<cfoutput>#order_codes.ORDER_CODE#</cfoutput>';
		window.opener.document.search_product.order_id.value = '';
		
		window.opener.document.info_form.order_code.value = '<cfoutput>#order_codes.ORDER_CODE#</cfoutput>';
		window.opener.document.info_form.order_id.value = '';
	</script>
</cfif>


<cfquery name="order_grup" datasource="#dsn3#">
	SELECT
    DISTINCT
 	O.COMPANY_ID, 
    O.PROJECT_ID,
    (SELECT NICKNAME  FROM #dsn#.COMPANY WHERE COMPANY_ID = O.COMPANY_ID) AS COMPANY,
    (SELECT PROJECT_HEAD FROM #dsn#.PRO_PROJECTS WHERE PROJECT_ID = O.PROJECT_ID) AS PROJE,
    O.ORDER_DATE
    FROM
    ORDERS AS O
    WHERE
    O.ORDER_ID IN (#order_id_list#) 
    AND O.ORDER_STAGE = #valid_order_stage_#
</cfquery>
<cfset set_id = 0>
<cfset order_list = ''>
<cfform name="add_" method="post" action="#request.self#?fuseaction=retail.popup_print_siparis&iframe=1">
<table class="medium_list">
<tr>
<td style="text-align:left;" class="headbold">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Sipariş Kodu : (<cfoutput>#order_code_list#</cfoutput>)
&nbsp;&nbsp;
<a href="javascript://" onClick="return gonder_print();"><img src="/images/print.gif" title="Yazdır" align="absbottom" border="0"></a>
<a href="javascript://" onClick="return gonder_mail();"><img src="/images/mail/reply_all.jpg" title="Mail Gönder" align="absbottom" border="0"></a>
<a href="javascript://" onClick="return gonder_mail_tekli();"><img src="/images/mail/forward.jpg" title="Tek Tek Mail Gönder" align="absbottom" border="0"></a>
&nbsp;
Mail İçeriği 
<select name="mail_type" id="mail_type">
    <option value="pdf">pdf</option>
    <option value="xls">excel</option>
</select>
<cfif isdefined("session.ep.userid")>
    <a href="javascript://" onClick="$('#mail_content').toggle();"><img src="/images/add_not.gif" title="Mail İçeriğini Düzenle" align="absbottom" border="0"></a>
</cfif>
</td>
</tr>
</table>
<cfif isdefined("session.ep.userid")>
<table width="99%" align="center">
	<tr>
    	<td>
        	<cf_box id="mail_content" title="Mail İçeriği" style="display:none;" closable="0" collapsable="0">
                <table>
                	<tr>
                    	<td width="65">Başlık</td>
                        <td><input type="text" name="siparis_baslik" id="siparis_baslik" value="Gülgen Market Sipariş Maili" style="width:400px;"/></td>
                    </tr>
                    <tr>
                    	<td colspan="2">
                        	<cfmodule
                                template="../../../../fckeditor/fckeditor.cfm"
                                toolbarset="Basic"
                                basepath="/fckeditor/"
                                instancename="siparis_icerik"
                                valign="top"
                                value="<b>Sayın Yetkili;</b> <br>Sipariş Detaylarınız Ekli Belgededir!"
                                width="500"
                                height="180">
                        </td>
                    </tr>
                </table>
            </cf_box>
        </td>
    </tr>
</table>
<cfelse>
	<input type="hidden" name="siparis_baslik" id="siparis_baslik" value="Gülgen Market Sipariş Maili" style="width:400px;"/>
    <input type="hidden" name="siparis_icerik" id="siparis_icerik" value="<cfoutput><b>Sayın Yetkili;</b> <br>Sipariş Detaylarınız Ekli Belgededir!</cfoutput>" style="width:400px;"/>
</cfif>
<cfoutput query="order_grup">
	<cfset set_id = set_id+1>
	
	<cfquery name="order_detail" datasource="#dsn3#">
        SELECT
            DISTINCT
            O.ORDER_ID,
            O.ORDER_NUMBER,
            O.COMPANY_ID,    
            O.ORDER_HEAD,
            (SELECT NICKNAME  FROM #dsn#.COMPANY WHERE COMPANY_ID = O.COMPANY_ID) AS COMPANY,
            (SELECT PROJECT_HEAD FROM #dsn#.PRO_PROJECTS WHERE PROJECT_ID = O.PROJECT_ID) AS PROJE,
            (SELECT DEPARTMENT_HEAD FROM #DSN#.DEPARTMENT WHERE DEPARTMENT_ID = O.DELIVER_DEPT_ID) AS DEPARTMENT,
            O.ORDER_DATE,
            O.DELIVERDATE,
            O.IS_MAIL
        FROM
            ORDERS AS O
        WHERE
            O.ORDER_DATE = '#order_grup.ORDER_DATE#' AND 
         	O.COMPANY_ID = #order_grup.COMPANY_ID# AND 
			<cfif len(order_grup.PROJECT_ID)>
            O.PROJECT_ID = #order_grup.PROJECT_ID# AND
            <cfelse>
                O.PROJECT_ID IS NULL AND
            </cfif> 
        	O.ORDER_ID IN (#order_id_list#)
    </cfquery>
<cfset order_list = valuelist(order_detail.order_id)>
<cfsavecontent variable="header_">
<table cellpadding="0" cellspacing="0">
<tr>
<td><input type="checkbox" name="select_order" id="select_order_#set_id#" value="#order_list#"/></td>
<td>
<input type="hidden" name="order_list_#set_id#" id="order_list_#set_id#" value="#order_list#"/> 
<a href="javascript://" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_print_files_all&orders=#order_list#&print_type=91','page')"><img src="/images/print.gif" /></a>
</td>
<td>
<a href="javascript://" onclick="show_hide('#set_id#')">#order_grup.COMPANY# <cfif len(order_grup.PROJE)>(#order_grup.PROJE#)</cfif> - #dateformat(order_grup.order_date,'dd/mm/yyyy')#</a>
</td>
<cfif isdefined("session.ep.userid")>
    <td><a href="javascript://" onclick="manage_company_mails('#order_grup.COMPANY_ID#','#set_id#')"><img src="/images/add_1.gif" title="Mail Ekle" align="absbottom" border="0"></a></td>
</cfif>
<td>
    <div id="div_order_mail_#set_id#">
    <cfquery name="get_comp_partners" datasource="#dsn#">
        SELECT
            *
        FROM
            COMPANY_PARTNER
        WHERE
            COMPANY_ID = #order_grup.COMPANY_ID# AND
            COMPANY_PARTNER_EMAIL IS NOT NULL AND
            COMPANY_PARTNER_EMAIL <> '' AND
            COMPANY_PARTNER_STATUS = 1
    </cfquery>
    <select name="order_mail_#set_id#" id="order_mail_#set_id#">
        <cfloop query="get_comp_partners">
            <option value="#COMPANY_PARTNER_EMAIL#">#COMPANY_PARTNER_EMAIL#</option>
        </cfloop>
    </select>
    <script>
		$("##order_mail_#set_id#").jqxDropDownList({placeHolder: "Mail Adresi Seçiniz",autoOpen: true,checkboxes: true,autoDropDownHeight: true,checkboxes: true, width:300, height: 25 });
		$("##order_mail_#set_id#").jqxDropDownList('uncheckAll'); 
	</script>
</td>
</tr>
</table>
</cfsavecontent>

<cf_medium_list_search title="#header_#"></cf_medium_list_search>
<div style="height:auto; overflow:auto;" id="#set_id#">
<cf_medium_list> 
			<thead>     
				<tr> 
					<th width="35">No</th>
					<th width="70">Depo</th>
					<th width="70">Belge Tarihi</th>
					<th width="75">Teslim Tarihi</th>
					<th>Şirket</th>				              
					<th>Konu</th>	
					<th width="35">&nbsp;</th>
				  </tr>
				  </thead>
				  <tbody>
					<cfloop query="order_detail" startrow="1" endrow="#order_detail.recordcount#">
					<tr>                            	
						<td><a href="#request.self#?fuseaction=purchase.detail_order&order_id=#ORDER_ID#" target="parent">#order_number#</a></td>
						<td>#department#</td>
						<td>#dateformat(order_date,'dd/mm/yyyy')#</td>
						<td>#dateformat(deliverdate,'dd/mm/yyyy')#</td>
						<td>#company# #proje#</td>
						<td><a href="#request.self#?fuseaction=purchase.detail_order&order_id=#ORDER_ID#" target="parent">#order_head#</a></td>
						<td style="<cfif order_detail.IS_MAIL eq 1>background-color:green;</cfif>">
                        <a href="javascript://" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#ORDER_ID#&print_type=91','page')"><img src="/images/print.gif" /></a>
                        <a href="javascript://" onclick="javascript:gonder_mail_alone('#order_id#','#set_id#');"><img src="/images/mail.gif" /></a>
                        </td> 
					</tr>                 
					</cfloop>
				  </tbody>
  </cf_medium_list>         
	</div>
</cfoutput>
</cfform>

<form name="print_screen" action="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_mail_siparis&iframe=1" method="post">
	<input type="hidden" name="is_alone" value="0"/>
    <input type="hidden" name="is_all_mail" value="0"/>
    <input type="hidden" name="is_one_one" value="0"/>
    <input type="hidden" name="order_id" value=""/>
    <input type="hidden" name="mail_adress" value=""/>
    <input type="hidden" name="mail_type" value="0"/>
    <input type="hidden" name="siparis_baslik" value=""/>
    <input type="hidden" name="siparis_icerik" value=""/>
    <input type="hidden" name="set_id" value="<cfoutput>#set_id#</cfoutput>"/>
    <input type="hidden" name="set_ids" id="set_ids" value=""/>
    <cfloop from="1" to="#set_id#" index="ccc">
    	<cfoutput>
        <input type="hidden" name="f_order_list_#ccc#" id="f_order_list_#ccc#" value=""/>
        <input type="hidden" name="f_mail_adress_#ccc#" id="f_mail_adress_#ccc#" value=""/>
        </cfoutput>
    </cfloop>
</form>
<script>
	function refresh_mails(company_id,set_id)
	{
		adres = '<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_get_company_mails&iframe=0';
		adres = adres + '&company_id=' + company_id;
		adres = adres + '&set_id=' + set_id;
		AjaxPageLoad(adres,'div_order_mail_' + set_id,'1');	
	}
	function manage_company_mails(company_id,set_id)
	{
		adres = '<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_manage_company_mails&iframe=0';
		adres = adres + '&company_id=' + company_id;
		adres = adres + '&set_id=' + set_id;
		windowopen(adres,'page','manage_mails');
	}
	
	function gonder_print()
	{
		windowopen('','page','print_popup_siparis2');
		document.add_.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_print_siparis&iframe=1';
		document.add_.target = 'print_popup_siparis2';
		add_.submit();
	}
	
	function gonder_mail()
	{
		document.print_screen.mail_type.value = document.getElementById('mail_type').value;
		document.print_screen.is_alone.value = '0';
		document.print_screen.is_all_mail.value = '1';
		document.print_screen.is_one_one.value = '0';
		document.print_screen.order_id.value = "";
		document.print_screen.siparis_baslik.value = document.getElementById('siparis_baslik').value;
		document.print_screen.siparis_icerik.value = CKEDITOR.instances.siparis_icerik.document.getBody().getHtml();
		
		grup_sayisi_ = '<cfoutput>#set_id#</cfoutput>';
		secililer = '';
		
		for(var k=1; k <= grup_sayisi_; k++)
		{
			document.getElementById('f_order_list_' + k).value = document.getElementById('order_list_' + k).value;
			
			var items = $("#order_mail_" + k).jqxDropDownList('getCheckedItems');
			var mail_ = "";
			$.each(items, function (index) 
			{
				mail_ += this.value + ", ";                          
			});
			document.getElementById('f_mail_adress_' + k).value = mail_;
			
			if(document.getElementById('select_order_' + k).checked == true)
			{
				secililer = secililer + ',' + k;
				if(document.getElementById('f_mail_adress_' + k).value == '')
				{
					alert('Seçili Grup İçin Mail Adresi Seçmelisiniz!\nGrup No:' + k);
					return false;	
				}
			}
		}
		
		if(secililer == '')
		{
			alert('Mail Gönderilecek Grup Seçmediniz!');	
			return false;
		}
		
		document.getElementById('set_ids').value = secililer;
		windowopen('','page','print_popup_siparis2');
		document.print_screen.target = 'print_popup_siparis2';
		print_screen.submit();
	}
	
	function gonder_mail_tekli()
	{
		document.print_screen.mail_type.value = document.getElementById('mail_type').value;
		document.print_screen.is_alone.value = '0';
		document.print_screen.is_all_mail.value = '0';
		document.print_screen.is_one_one.value = '1';
		document.print_screen.order_id.value = "";
		document.print_screen.siparis_baslik.value = document.getElementById('siparis_baslik').value;
		document.print_screen.siparis_icerik.value = CKEDITOR.instances.siparis_icerik.document.getBody().getHtml();
		
		grup_sayisi_ = '<cfoutput>#set_id#</cfoutput>';
		secililer = '';
		
		for(var k=1; k <= grup_sayisi_; k++)
		{
			document.getElementById('f_order_list_' + k).value = document.getElementById('order_list_' + k).value;
			
			var items = $("#order_mail_" + k).jqxDropDownList('getCheckedItems');
			var mail_ = "";
			$.each(items, function (index) 
			{
				mail_ += this.value + ", ";                          
			});
			document.getElementById('f_mail_adress_' + k).value = mail_;
			
			if(document.getElementById('select_order_' + k).checked == true)
			{
				secililer = secililer + ',' + k;
				if(document.getElementById('f_mail_adress_' + k).value == '')
				{
					alert('Seçili Grup İçin Mail Adresi Seçmelisiniz!\nGrup No:' + k);
					return false;	
				}
			}
		}
		
		if(secililer == '')
		{
			alert('Mail Gönderilecek Grup Seçmediniz!');	
			return false;
		}
		
		document.getElementById('set_ids').value = secililer;
		windowopen('','page','print_popup_siparis2');
		document.print_screen.target = 'print_popup_siparis2';
		print_screen.submit();
	}
	
	function gonder_mail_alone(order_id_,set_id_)
	{
		var items = $("#order_mail_" + set_id_).jqxDropDownList('getCheckedItems');
		var mail_ = "";
		$.each(items, function (index) 
		{
			mail_ += this.value + ", ";                          
		});
		if(mail_ == '')
		{
			alert('Mail Adresi Tanımlı Değil!');
			return false;	
		}
		document.print_screen.mail_type.value = document.getElementById('mail_type').value;
		document.print_screen.is_alone.value = '1';
		document.print_screen.is_all_mail.value = '0';
		document.print_screen.is_one_one.value = '0';
		document.print_screen.mail_adress.value = mail_;
		document.print_screen.order_id.value = order_id_;
		document.print_screen.siparis_baslik.value = document.getElementById('siparis_baslik').value;
		document.print_screen.siparis_icerik.value = CKEDITOR.instances.siparis_icerik.document.getBody().getHtml();
		windowopen('','page','print_popup_siparis2');
		document.print_screen.target = 'print_popup_siparis2';
		print_screen.submit();
	}
</script>
